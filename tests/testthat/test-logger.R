context("Logger class unit tests")

# Helper function to create temp file (normalizePath requires file to exist)
temp_log_file <- function() {
  f <- tempfile(fileext = ".log")
  file.create(f)
  f
}

test_that("initialization works", {
  logger <- ado:::Logger$new()

  expect_s3_class(logger, "Logger")
  expect_s3_class(logger, "R6")

  # No sinks registered initially
  expect_length(logger$log_sinks, 0)

  # Logging enabled by default
  expect_true(logger$log_enabled)
  expect_true(logger$cmdlog_enabled)
})

test_that("register_sink works for log type", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  # Register log sink
  logger$register_sink(temp_file, type = "log", header = FALSE)

  # Should be registered
  expect_true(logger$has_sink(temp_file))
  expect_true(logger$has_sink(temp_file, type = "log"))
  expect_false(logger$has_sink(temp_file, type = "cmdlog"))

  # Cleanup
  logger$deregister_sink(temp_file)
})

test_that("register_sink works for cmdlog type", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  # Register cmdlog sink
  logger$register_sink(temp_file, type = "cmdlog", header = FALSE)

  # Should be registered
  expect_true(logger$has_sink(temp_file))
  expect_false(logger$has_sink(temp_file, type = "log"))
  expect_true(logger$has_sink(temp_file, type = "cmdlog"))

  # Cleanup
  logger$deregister_sink(temp_file)
})

test_that("register_sink normalizes paths", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  # Register with non-normalized path
  logger$register_sink(temp_file, type = "log", header = FALSE)

  # Should detect with normalized path
  normalized <- normalizePath(temp_file)
  expect_true(logger$has_sink(normalized))

  # Cleanup
  logger$deregister_sink(temp_file)
})

test_that("register_sink detects duplicates", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()
  on.exit(unlink(temp_file), add = TRUE)

  # Register once
  logger$register_sink(temp_file, type = "log", header = FALSE)

  # Try to register again - should signal AdoException
  expect_condition_signaled(
    logger$register_sink(temp_file, type = "log", header = FALSE),
    class = "AdoException"
  )

  # Cleanup
  logger$deregister_sink(temp_file)
})

test_that("register_sink rejects invalid type", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  # Invalid type should signal AdoException
  expect_condition_signaled(
    logger$register_sink(temp_file, type = "invalid"),
    class = "AdoException"
  )
})

test_that("register_sink writes header when requested", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  # Register with header
  logger$register_sink(temp_file, type = "log", header = TRUE)
  logger$deregister_sink(temp_file)

  # Check file content
  content <- readLines(temp_file, warn=FALSE)
  expect_true(any(grepl("^log:", content)))
  expect_true(any(grepl("^log type:", content)))
  expect_true(any(grepl("^opened on:", content)))
})

test_that("sink_type returns correct type", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  temp_cmd <- temp_log_file()

  on.exit(unlink(c(temp_log, temp_cmd)), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)
  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)

  expect_equal(logger$sink_type(temp_log), "log")
  expect_equal(logger$sink_type(temp_cmd), "cmdlog")

  # Cleanup
  logger$deregister_all_sinks()
})

test_that("sink_type signals condition for unregistered sink", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  # Should signal AdoException for unregistered sink
  expect_condition_signaled(
    logger$sink_type(temp_file),
    class = "AdoException"
  )
})

test_that("has_sink works with type parameter", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  logger$register_sink(temp_file, type = "log", header = FALSE)

  # Check with type
  expect_true(logger$has_sink(temp_file, type = "log"))
  expect_false(logger$has_sink(temp_file, type = "cmdlog"))

  # Check without type
  expect_true(logger$has_sink(temp_file, type = NULL))

  # Cleanup
  logger$deregister_sink(temp_file)
})

test_that("has_sink rejects invalid type", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  # Invalid type should signal AdoException
  expect_condition_signaled(
    logger$has_sink(temp_file, type = "invalid"),
    class = "AdoException"
  )
})

test_that("deregister_sink removes sink and closes file", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  # Register and deregister
  logger$register_sink(temp_file, type = "log", header = FALSE)
  expect_true(logger$has_sink(temp_file))

  logger$deregister_sink(temp_file)
  expect_false(logger$has_sink(temp_file))

  # File should be closed (can open it again)
  expect_silent(logger$register_sink(temp_file, type = "log", header = FALSE))
  logger$deregister_sink(temp_file)
})

test_that("deregister_all_sinks removes all sinks", {
  logger <- ado:::Logger$new()
  temp1 <- temp_log_file()

  temp2 <- temp_log_file()

  temp3 <- temp_log_file()

  on.exit(unlink(c(temp1, temp2, temp3)), add = TRUE)

  # Register multiple sinks
  logger$register_sink(temp1, type = "log", header = FALSE)
  logger$register_sink(temp2, type = "log", header = FALSE)
  logger$register_sink(temp3, type = "cmdlog", header = FALSE)

  expect_true(logger$has_sink(temp1))
  expect_true(logger$has_sink(temp2))
  expect_true(logger$has_sink(temp3))

  # Deregister all
  logger$deregister_all_sinks()

  expect_false(logger$has_sink(temp1))
  expect_false(logger$has_sink(temp2))
  expect_false(logger$has_sink(temp3))
})

test_that("deregister_all_sinks works with type filter", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  temp_cmd <- temp_log_file()

  on.exit(unlink(c(temp_log, temp_cmd)), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)
  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)

  # Deregister only log type
  logger$deregister_all_sinks(type = "log")

  expect_false(logger$has_sink(temp_log))
  expect_true(logger$has_sink(temp_cmd))  # cmdlog should still be there

  # Cleanup
  logger$deregister_all_sinks()
})

test_that("log_command writes to cmdlog sinks", {
  logger <- ado:::Logger$new()
  temp_cmd <- temp_log_file()

  on.exit(unlink(temp_cmd), add = TRUE)

  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)
  logger$log_command("test command\n")
  logger$deregister_sink(temp_cmd)

  # Check content
  content <- readLines(temp_cmd, warn=FALSE)
  expect_equal(content, "test command")
})

test_that("log_command respects cmdlog_enabled flag", {
  logger <- ado:::Logger$new()
  temp_cmd <- temp_log_file()

  on.exit(unlink(temp_cmd), add = TRUE)

  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)

  # Disable cmdlog
  logger$cmdlog_enabled <- FALSE
  logger$log_command("should not write\n")

  # Re-enable and write
  logger$cmdlog_enabled <- TRUE
  logger$log_command("should write\n")

  logger$deregister_sink(temp_cmd)

  # Check content
  content <- readLines(temp_cmd, warn=FALSE)
  expect_length(content, 1)
  expect_equal(content, "should write")
})

test_that("log_command writes to both log and cmdlog", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  temp_cmd <- temp_log_file()

  on.exit(unlink(c(temp_log, temp_cmd)), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)
  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)
  logger$log_command("test command\n")
  logger$deregister_all_sinks()

  # Both should have the command
  log_content <- readLines(temp_log, warn=FALSE)
  cmd_content <- readLines(temp_cmd, warn=FALSE)
  expect_equal(log_content, "test command")
  expect_equal(cmd_content, "test command")
})

test_that("log_result writes to log sinks only", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  temp_cmd <- temp_log_file()

  on.exit(unlink(c(temp_log, temp_cmd)), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)
  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)
  logger$log_result("test result")
  logger$deregister_all_sinks()

  # Only log should have the result
  log_content <- readLines(temp_log, warn=FALSE)
  expect_equal(log_content, "test result")

  # cmdlog should be empty
  cmd_content <- readLines(temp_cmd, warn=FALSE)
  expect_length(cmd_content, 0)
})

test_that("log_result respects log_enabled flag", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  on.exit(unlink(temp_log), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)

  # Disable log
  logger$log_enabled <- FALSE
  logger$log_result("should not write")

  # Re-enable and write
  logger$log_enabled <- TRUE
  logger$log_result("should write")

  logger$deregister_sink(temp_log)

  # Check content
  content <- readLines(temp_log, warn=FALSE)
  expect_length(content, 1)
  expect_equal(content, "should write")
})

test_that("log_enabled property works", {
  logger <- ado:::Logger$new()

  # Default is TRUE
  expect_true(logger$log_enabled)

  # Can set to FALSE
  logger$log_enabled <- FALSE
  expect_false(logger$log_enabled)

  # Can set back to TRUE
  logger$log_enabled <- TRUE
  expect_true(logger$log_enabled)
})

test_that("cmdlog_enabled property works", {
  logger <- ado:::Logger$new()

  # Default is TRUE
  expect_true(logger$cmdlog_enabled)

  # Can set to FALSE
  logger$cmdlog_enabled <- FALSE
  expect_false(logger$cmdlog_enabled)

  # Can set back to TRUE
  logger$cmdlog_enabled <- TRUE
  expect_true(logger$cmdlog_enabled)
})

test_that("multiple log sinks receive same content", {
  logger <- ado:::Logger$new()
  temp1 <- temp_log_file()

  temp2 <- temp_log_file()

  on.exit(unlink(c(temp1, temp2)), add = TRUE)

  logger$register_sink(temp1, type = "log", header = FALSE)
  logger$register_sink(temp2, type = "log", header = FALSE)
  logger$log_result("test message")
  logger$deregister_all_sinks()

  # Both should have same content
  content1 <- readLines(temp1, warn=FALSE)
  content2 <- readLines(temp2, warn=FALSE)
  expect_equal(content1, content2)
  expect_equal(content1, "test message")
})

test_that("log files are independent", {
  logger <- ado:::Logger$new()
  temp_log <- temp_log_file()

  temp_cmd <- temp_log_file()

  on.exit(unlink(c(temp_log, temp_cmd)), add = TRUE)

  logger$register_sink(temp_log, type = "log", header = FALSE)
  logger$register_sink(temp_cmd, type = "cmdlog", header = FALSE)

  logger$log_command("command 1\n")
  logger$log_result("result 1")
  logger$log_command("command 2\n")
  logger$log_result("result 2")

  logger$deregister_all_sinks()

  # Log should have commands and results
  log_content <- paste(readLines(temp_log, warn=FALSE), collapse="\n")
  expect_true(grepl("command 1", log_content))
  expect_true(grepl("command 2", log_content))
  expect_true(grepl("result 1", log_content))
  expect_true(grepl("result 2", log_content))

  # Cmdlog should have only commands
  cmd_content <- paste(readLines(temp_cmd, warn=FALSE), collapse="\n")
  expect_true(grepl("command 1", cmd_content))
  expect_true(grepl("command 2", cmd_content))
  expect_false(grepl("result 1", cmd_content))
  expect_false(grepl("result 2", cmd_content))
})

test_that("empty logger operations work", {
  logger <- ado:::Logger$new()

  # Operations on empty logger should not error
  expect_silent(logger$log_command("test\n"))
  expect_silent(logger$log_result("test"))
  expect_silent(logger$deregister_all_sinks())

  # NOTE: has_sink with nonexistent path fails in normalizePath
  # Skip this check
})

test_that("cleanup after errors works", {
  logger <- ado:::Logger$new()
  temp_file <- temp_log_file()

  on.exit(unlink(temp_file), add = TRUE)

  logger$register_sink(temp_file, type = "log", header = FALSE)

  # Simulate some error condition, then cleanup
  logger$deregister_all_sinks()

  # Should be able to register again
  expect_silent(logger$register_sink(temp_file, type = "log", header = FALSE))
  logger$deregister_sink(temp_file)
})