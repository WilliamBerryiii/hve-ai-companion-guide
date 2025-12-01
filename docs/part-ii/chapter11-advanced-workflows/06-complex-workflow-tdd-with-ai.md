---
title: Complex Workflow - TDD with AI
description: Master test-driven development using AI assistance while maintaining TDD discipline and quality standards
author: HVE Core Team
ms.date: 2025-11-19
ms.topic: how-to
keywords:
  - test-driven development
  - TDD
  - red-green-refactor
  - edit mode
  - testing strategies
estimated_reading_time: 8
---

Test-driven development transforms how you write code. Instead of implementing features and hoping they work, you write tests first. These tests define requirements clearly and catch problems early.

AI assistance accelerates TDD workflows while maintaining discipline. Edit Mode gives you control over the test-first sequence. You review each test before implementation and verify implementations match test intent.

This section demonstrates systematic TDD workflows using AI assistance.

## Test-Driven Development Review

The traditional TDD cycle follows three phases: Red, Green, and Refactor.

**Red phase:** Write a failing test that defines the desired behavior. Run the test to confirm it fails. This validates your test actually checks something.

**Green phase:** Write minimal code to make the test pass. Don't add extra features or optimizations. Focus solely on satisfying the test requirements.

**Refactor phase:** Improve the code while keeping tests green. Clean up duplication, improve names, and enhance structure. Tests provide safety for these changes.

**TDD benefits:**

* Tests define requirements with executable specifications
* Confidence to refactor without breaking existing functionality
* Living documentation showing how code should behave
* Early detection of regressions and integration issues

**Challenge with AI:** Agent Mode might implement features before writing tests. You need to enforce test-first discipline explicitly. Balance AI speed with TDD rigor.

## Edit+RPI for TDD Workflows

Edit Mode provides the control TDD requires. You maintain the test-first sequence while leveraging AI assistance.

**Why Edit Mode works for TDD:**

* **Control over order:** You specify Red, Green, or Refactor phase explicitly
* **Review before proceeding:** Examine each test before implementation begins
* **Verify intent match:** Confirm implementations satisfy test requirements exactly
* **Maintain discipline:** Explicit phase transitions prevent skipping steps

**TDD workflow pattern:**

```text
Research → Plan → Implement with Edit Mode in TDD cycles

Research Phase: Understand requirements and testing strategy
Planning Phase: Break work into TDD cycles with test specifications
Implementation Phase: Execute Red-Green-Refactor cycles with Edit Mode
```

## Complete TDD Example: Pipeline Service with Agent Handoffs

This example demonstrates TDD with **Beads workflow agent handoffs** for building a C# data pipeline service, following patterns from the Edge-AI project. You'll see how specialized agents coordinate through handoff documents:

* **Test design agents** plan comprehensive test coverage with read-only tools
* **Implementation agents** write code following specifications with full tool access
* **Verification agents** validate quality gates before advancing phases

### Scenario: Event Processing Pipeline

We're building a `PipelineService` that receives events from a queue, validates data structure, transforms to internal format, and writes to storage.

### Phase 1: Test Design Agent Creates Test Specifications

The **Test Design Agent** operates with read-only tools (`read_file`, `grep_search`, `semantic_search`, `list_dir`) to prevent accidental code changes during the specification phase. This constraint ensures the agent focuses purely on analysis and test design.

**Agent Prompt:**

```markdown
Research C# testing patterns in this codebase and create comprehensive test specifications 
for a new PipelineService class that will:
1. Read messages from a queue (IQueueClient)
2. Validate incoming events
3. Transform data
4. Write to storage (IStorageWriter)

Create test specifications following Given-When-Then naming conventions and identify 
all dependencies that need mocking with NSubstitute.
```

**Agent Actions:**

1. `semantic_search` - "C# test patterns NSubstitute mocking conventions"
2. `grep_search` - "\\[Fact\\]|\\[Theory\\]" to find existing test structure
3. `read_file` - Review 2-3 existing test files for naming patterns
4. `list_dir` - Survey test project structure

**Generated Output:** `.copilot-handoffs/test-design-pipeline-001.md`

```markdown
# Test Design Specification: PipelineService
**Agent:** Test Design Agent (Read-Only)
**Date:** 2025-11-23
**Status:** Test Specifications Complete

## Test Class Structure

**Class:** `PipelineServiceTests`
**System Under Test:** `PipelineService`

## Dependencies to Mock

- `IQueueClient` - Message queue operations
- `IStorageWriter` - Storage persistence
- `ILogger<PipelineService>` - Logging infrastructure

## Test Specifications

### Happy Path Tests

#### 1. Given_ValidMessage_When_ProcessDataAsync_Then_WritesToStorage
**Acceptance Criteria:**
- [ ] Mock returns valid JSON message from queue
- [ ] Service parses and validates event
- [ ] Service transforms event to ProcessedEvent
- [ ] Storage writer receives transformed data
- [ ] Returns success result

#### 2. Given_MultipleMessages_When_ProcessDataAsync_Then_ProcessesInOrder
**Acceptance Criteria:**
- [ ] Queue returns 3 valid messages
- [ ] All messages processed sequentially
- [ ] Storage receives 3 write calls in order
- [ ] No messages skipped

### Validation Error Tests

#### 3. Given_NullMessage_When_ProcessDataAsync_Then_ReturnsValidationError
**Acceptance Criteria:**
- [ ] Queue returns null message
- [ ] Service validates input
- [ ] Returns error without calling storage
- [ ] Logs warning

#### 4. Given_InvalidJson_When_ProcessDataAsync_Then_ReturnsParseError
**Acceptance Criteria:**
- [ ] Queue returns malformed JSON
- [ ] Service catches parse exception
- [ ] Returns error result
- [ ] Does not call storage

#### 5. Given_MissingRequiredField_When_ProcessDataAsync_Then_ReturnsValidationError
**Acceptance Criteria:**
- [ ] Message missing EventType property
- [ ] Validation detects missing field
- [ ] Returns validation error
- [ ] Logs validation failure

### Infrastructure Error Tests

#### 6. Given_QueueFailure_When_ProcessDataAsync_Then_PropagatesException
**Acceptance Criteria:**
- [ ] Queue client throws exception
- [ ] Service does not catch queue errors
- [ ] Exception propagates to caller
- [ ] No storage calls made

#### 7. Given_StorageFailure_When_ProcessDataAsync_Then_ReturnsStorageError
**Acceptance Criteria:**
- [ ] Storage writer throws exception
- [ ] Service catches storage error
- [ ] Returns error result with details
- [ ] Logs storage failure

### Edge Cases

#### 8. Given_EmptyMessage_When_ProcessDataAsync_Then_ReturnsValidationError
**Acceptance Criteria:**
- [ ] Queue returns empty string
- [ ] Service validates non-empty requirement
- [ ] Returns appropriate error
- [ ] No parse attempt made

#### 9. Given_VeryLargeMessage_When_ProcessDataAsync_Then_ProcessesSuccessfully
**Acceptance Criteria:**
- [ ] Queue returns 1MB message
- [ ] Service handles large payload
- [ ] Transformation completes
- [ ] Storage write succeeds

## Implementation Guidance

**Test Structure:** Use Arrange-Act-Assert pattern
**Mocking Library:** NSubstitute with `Substitute.For<T>()`
**Async Pattern:** All tests should be async Task methods
**Naming:** Follow Given-When-Then convention strictly

## Next Agent

**Handoff to:** Implementation Agent (Full Tools)
**Task:** Implement failing tests based on these specifications
**Expected Output:** Complete test class with all 9 test methods
```

> [!TIP]
> The read-only tool restriction is critical for the Test Design Agent. Without write access, the agent cannot accidentally modify production code or create incomplete implementations. This separation of concerns ensures test specifications are thoroughly researched before any code is written. For production Beads workflows using specialized agents across multiple engineering scenarios, see Part III, Chapter 14 (Custom Agents and Workflow Orchestration).

### Phase 2: Implementation Agent - RED Phase

The **Implementation Agent** has full tool access (`read_file`, `create_file`, `replace_string_in_file`, `run_in_terminal`) to create the test implementation. The goal is to write failing tests that capture the specifications exactly.

**Agent Prompt:**

```markdown
Implement the test specifications from .copilot-handoffs/test-design-pipeline-001.md as 
a complete C# test class. Use NSubstitute for mocking and follow the Given-When-Then 
naming convention. Tests should fail with "type not found" since PipelineService 
doesn't exist yet.
```

**Generated Code:** `tests/PipelineServiceTests.cs`

```csharp
using Xunit;
using NSubstitute;
using FluentAssertions;

public class PipelineServiceTests
{
    private readonly IQueueClient _queueClient;
    private readonly IStorageWriter _storageWriter;
    private readonly ILogger<PipelineService> _logger;
    private readonly PipelineService _sut;

    public PipelineServiceTests()
    {
        _queueClient = Substitute.For<IQueueClient>();
        _storageWriter = Substitute.For<IStorageWriter>();
        _logger = Substitute.For<ILogger<PipelineService>>();
        _sut = new PipelineService(_queueClient, _storageWriter, _logger);
    }

    [Fact]
    public async Task Given_ValidMessage_When_ProcessDataAsync_Then_WritesToStorage()
    {
        // Arrange
        var json = "{\"EventType\":\"UserAction\",\"UserId\":123,\"Timestamp\":\"2025-11-23T10:00:00Z\"}";
        _queueClient.ReadMessageAsync().Returns(json);

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeTrue();
        await _storageWriter.Received(1).WriteAsync(Arg.Any<ProcessedEvent>());
    }

    [Fact]
    public async Task Given_MultipleMessages_When_ProcessDataAsync_Then_ProcessesInOrder()
    {
        // Arrange
        _queueClient.ReadMessageAsync().Returns(
            "{\"EventType\":\"Action1\",\"UserId\":1,\"Timestamp\":\"2025-11-23T10:00:00Z\"}",
            "{\"EventType\":\"Action2\",\"UserId\":2,\"Timestamp\":\"2025-11-23T10:01:00Z\"}",
            "{\"EventType\":\"Action3\",\"UserId\":3,\"Timestamp\":\"2025-11-23T10:02:00Z\"}"
        );

        // Act
        await _sut.ProcessDataAsync();
        await _sut.ProcessDataAsync();
        await _sut.ProcessDataAsync();

        // Assert
        await _storageWriter.Received(3).WriteAsync(Arg.Any<ProcessedEvent>());
    }

    [Fact]
    public async Task Given_NullMessage_When_ProcessDataAsync_Then_ReturnsValidationError()
    {
        // Arrange
        _queueClient.ReadMessageAsync().Returns((string)null);

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Contain("validation");
        await _storageWriter.DidNotReceive().WriteAsync(Arg.Any<ProcessedEvent>());
    }

    [Fact]
    public async Task Given_InvalidJson_When_ProcessDataAsync_Then_ReturnsParseError()
    {
        // Arrange
        _queueClient.ReadMessageAsync().Returns("{invalid json");

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Contain("parse");
    }

    [Fact]
    public async Task Given_MissingRequiredField_When_ProcessDataAsync_Then_ReturnsValidationError()
    {
        // Arrange
        var json = "{\"UserId\":123,\"Timestamp\":\"2025-11-23T10:00:00Z\"}"; // Missing EventType

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Contain("EventType");
    }

    [Fact]
    public async Task Given_QueueFailure_When_ProcessDataAsync_Then_PropagatesException()
    {
        // Arrange
        _queueClient.ReadMessageAsync().Returns<string>(_ => throw new QueueException("Queue unavailable"));

        // Act & Assert
        await Assert.ThrowsAsync<QueueException>(() => _sut.ProcessDataAsync());
    }

    [Fact]
    public async Task Given_StorageFailure_When_ProcessDataAsync_Then_ReturnsStorageError()
    {
        // Arrange
        var json = "{\"EventType\":\"UserAction\",\"UserId\":123,\"Timestamp\":\"2025-11-23T10:00:00Z\"}";
        _queueClient.ReadMessageAsync().Returns(json);
        _storageWriter.WriteAsync(Arg.Any<ProcessedEvent>()).Returns<Task>(_ => throw new StorageException("Write failed"));

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeFalse();
        result.Error.Should().Contain("storage");
    }

    [Fact]
    public async Task Given_EmptyMessage_When_ProcessDataAsync_Then_ReturnsValidationError()
    {
        // Arrange
        _queueClient.ReadMessageAsync().Returns(string.Empty);

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeFalse();
    }

    [Fact]
    public async Task Given_VeryLargeMessage_When_ProcessDataAsync_Then_ProcessesSuccessfully()
    {
        // Arrange
        var largeData = new string('x', 1_000_000);
        var json = $"{{\"EventType\":\"LargeEvent\",\"UserId\":123,\"Data\":\"{largeData}\",\"Timestamp\":\"2025-11-23T10:00:00Z\"}}";
        _queueClient.ReadMessageAsync().Returns(json);

        // Act
        var result = await _sut.ProcessDataAsync();

        // Assert
        result.IsSuccess.Should().BeTrue();
    }
}
```

**Test Execution:**

```bash
$ dotnet test

❌ FAIL: 9 tests failed
- Error: The type or namespace name 'PipelineService' could not be found
```

**Generated Output:** `.copilot-handoffs/implementation-pipeline-001.md`

```markdown
# Implementation Handoff: PipelineService Tests - RED Phase
**Agent:** Implementation Agent (Full Tools)
**Date:** 2025-11-23
**Status:** RED Phase Complete

## Actions Taken

1. Created `tests/PipelineServiceTests.cs` with 9 test methods
2. Implemented all test specifications from test-design-pipeline-001.md
3. Used NSubstitute for mocking IQueueClient, IStorageWriter, ILogger
4. Followed Given-When-Then naming convention
5. Applied Arrange-Act-Assert structure

## Test Implementation Summary

- **Total Tests:** 9
- **Happy Path:** 2 tests
- **Validation Errors:** 3 tests
- **Infrastructure Errors:** 2 tests
- **Edge Cases:** 2 tests

## RED Phase Validation

✅ All tests fail with expected error: "PipelineService type not found"
✅ No test bugs detected (proper async/await, correct assertions)
✅ Mocks configured correctly with NSubstitute
✅ Tests are independent and isolated

## Next Agent

**Handoff to:** Verification Agent (Selective Tools)
**Task:** Validate RED phase completion and test quality
```

> [!NOTE]
> Tests must fail for the **right reason**. "Type not found" is correct for RED phase. If tests fail due to assertion bugs, incorrect mock setup, or syntax errors, the Implementation Agent must fix test code before proceeding. The RED phase validates test specifications, not production code.

### Phase 3: Verification Agent - RED Validation

The **Verification Agent** has selective tool access (`read_file`, `grep_search`, `run_in_terminal` for test execution) to validate the RED phase without the ability to modify code. This agent ensures quality gates before advancing.

**Agent Actions:**

1. `read_file` - Review `.copilot-handoffs/implementation-pipeline-001.md`
2. `read_file` - Inspect `tests/PipelineServiceTests.cs` for test structure
3. `run_in_terminal` - Execute `dotnet test` to confirm failure
4. `grep_search` - Verify Given-When-Then naming consistency

**Generated Output:** `.copilot-handoffs/verification-pipeline-001.md`

```markdown
# Verification Report: PipelineService Tests - RED Phase
**Agent:** Verification Agent (Selective Tools)
**Date:** 2025-11-23
**Status:** RED Phase Validated

## Test Specification Coverage

Reviewing test-design-pipeline-001.md acceptance criteria:

✅ **Test 1:** Valid message writes to storage - IMPLEMENTED
✅ **Test 2:** Multiple messages process in order - IMPLEMENTED
✅ **Test 3:** Null message returns validation error - IMPLEMENTED
✅ **Test 4:** Invalid JSON returns parse error - IMPLEMENTED
✅ **Test 5:** Missing required field returns validation error - IMPLEMENTED
✅ **Test 6:** Queue failure propagates exception - IMPLEMENTED
✅ **Test 7:** Storage failure returns storage error - IMPLEMENTED
✅ **Test 8:** Empty message returns validation error - IMPLEMENTED
✅ **Test 9:** Very large message processes successfully - IMPLEMENTED

## Quality Checks

### Test Structure
✅ All tests follow Arrange-Act-Assert pattern
✅ Given-When-Then naming convention applied consistently
✅ Each test has single responsibility
✅ Tests are independent (no shared state)

### Mocking Validation
✅ NSubstitute used correctly for all dependencies
✅ Mock return values configured in Arrange section
✅ Verification uses `Received()` and `DidNotReceive()` appropriately
✅ Constructor properly initializes mocks and SUT

### Edge Cases & Error Handling
✅ Null handling tested (Test 3)
✅ Empty string tested (Test 8)
✅ Parse errors tested (Test 4)
✅ Large payload tested (Test 9)
✅ Infrastructure failures tested (Tests 6, 7)

### Async Patterns
✅ All test methods return `async Task`
✅ Async mocks configured with `Returns()` correctly
✅ Await used on async calls
✅ `Assert.ThrowsAsync` used for exception tests

## RED Phase Validation

**Test Execution Result:**
```text

❌ 9 tests failed
Error: The type or namespace name 'PipelineService' could not be found

```

✅ **Correct Failure Reason:** Type not found (expected)
✅ **No Test Bugs:** All failures due to missing implementation
✅ **Ready for GREEN Phase:** Tests are well-structured

## Recommendations

No blocking issues. Tests are ready for implementation phase.

**Optional Improvements for Future Cycles:**

* Consider parameterized tests with `[Theory]` for validation scenarios
* Add data-driven tests for multiple invalid JSON formats

## Status

**RED Phase:** ✅ Complete and Validated
**Next Phase:** GREEN (Implementation)

## Next Agent

**Handoff to:** Implementation Agent (Full Tools)
**Task:** Implement PipelineService to make all tests pass

```text

### Phase 4: Implementation Agent - GREEN Phase

The **Implementation Agent** now creates the minimal production code necessary to make all tests pass. TDD discipline requires implementing only what the tests specify—no additional features.

**Agent Prompt:**

```markdown
Implement PipelineService to make all tests in PipelineServiceTests.cs pass. 
Follow the test specifications exactly. Use minimal implementation—no over-engineering.
Verify with `dotnet test` that all 9 tests pass.
```

**Generated Code:** `src/PipelineService.cs`

```csharp
using System;
using System.Text.Json;
using System.Threading.Tasks;

public class PipelineService
{
    private readonly IQueueClient _queueClient;
    private readonly IStorageWriter _storageWriter;
    private readonly ILogger<PipelineService> _logger;

    public PipelineService(
        IQueueClient queueClient,
        IStorageWriter storageWriter,
        ILogger<PipelineService> logger)
    {
        _queueClient = queueClient;
        _storageWriter = storageWriter;
        _logger = logger;
    }

    public async Task<Result> ProcessDataAsync()
    {
        try
        {
            var message = await _queueClient.ReadMessageAsync();

            if (string.IsNullOrEmpty(message))
            {
                _logger.LogWarning("Received null or empty message");
                return Result.Failure("Message validation failed: null or empty");
            }

            IncomingEvent incomingEvent;
            try
            {
                incomingEvent = JsonSerializer.Deserialize<IncomingEvent>(message);
            }
            catch (JsonException ex)
            {
                _logger.LogError(ex, "Failed to parse message");
                return Result.Failure($"Message parse error: {ex.Message}");
            }

            if (string.IsNullOrEmpty(incomingEvent?.EventType))
            {
                _logger.LogWarning("Missing required field: EventType");
                return Result.Failure("Validation error: EventType is required");
            }

            var processedEvent = new ProcessedEvent
            {
                EventType = incomingEvent.EventType,
                UserId = incomingEvent.UserId,
                ProcessedAt = DateTime.UtcNow,
                OriginalTimestamp = incomingEvent.Timestamp
            };

            try
            {
                await _storageWriter.WriteAsync(processedEvent);
            }
            catch (StorageException ex)
            {
                _logger.LogError(ex, "Storage write failed");
                return Result.Failure($"Storage error: {ex.Message}");
            }

            return Result.Success();
        }
        catch (QueueException)
        {
            throw; // Propagate queue exceptions as per Test 6
        }
    }
}

public class IncomingEvent
{
    public string EventType { get; set; }
    public int UserId { get; set; }
    public string Timestamp { get; set; }
    public string Data { get; set; }
}

public class ProcessedEvent
{
    public string EventType { get; set; }
    public int UserId { get; set; }
    public DateTime ProcessedAt { get; set; }
    public string OriginalTimestamp { get; set; }
}

public class Result
{
    public bool IsSuccess { get; private set; }
    public string Error { get; private set; }

    public static Result Success() => new Result { IsSuccess = true };
    public static Result Failure(string error) => new Result { IsSuccess = false, Error = error };
}
```

**Test Execution:**

```bash
$ dotnet test

✅ PASS: 9 tests passed
- Given_ValidMessage_When_ProcessDataAsync_Then_WritesToStorage
- Given_MultipleMessages_When_ProcessDataAsync_Then_ProcessesInOrder
- Given_NullMessage_When_ProcessDataAsync_Then_ReturnsValidationError
- Given_InvalidJson_When_ProcessDataAsync_Then_ReturnsParseError
- Given_MissingRequiredField_When_ProcessDataAsync_Then_ReturnsValidationError
- Given_QueueFailure_When_ProcessDataAsync_Then_PropagatesException
- Given_StorageFailure_When_ProcessDataAsync_Then_ReturnsStorageError
- Given_EmptyMessage_When_ProcessDataAsync_Then_ReturnsValidationError
- Given_VeryLargeMessage_When_ProcessDataAsync_Then_ProcessesSuccessfully

Total: 9 passed, 0 failed
```

**Generated Output:** `.copilot-handoffs/implementation-pipeline-002.md`

```markdown
# Implementation Handoff: PipelineService - GREEN Phase
**Agent:** Implementation Agent (Full Tools)
**Date:** 2025-11-23
**Status:** GREEN Phase Complete

## Actions Taken

1. Created `src/PipelineService.cs` with ProcessDataAsync method
2. Implemented dependency injection constructor
3. Added validation for null/empty messages
4. Implemented JSON parsing with error handling
5. Added EventType validation
6. Implemented event transformation logic
7. Added storage write with exception handling
8. Created IncomingEvent and ProcessedEvent models
9. Created Result class for operation outcomes

## Implementation Details

**Class:** PipelineService
**Method:** ProcessDataAsync() -> Task<Result>

**Flow:**
1. Read message from queue (propagate queue exceptions)
2. Validate message not null/empty
3. Parse JSON to IncomingEvent
4. Validate EventType present
5. Transform to ProcessedEvent
6. Write to storage (catch storage exceptions)
7. Return success/failure result

## Test Results

✅ All 9 tests passing
- Happy path: 2/2 ✅
- Validation: 3/3 ✅
- Infrastructure: 2/2 ✅
- Edge cases: 2/2 ✅

## TDD Compliance

✅ Minimal implementation (no extra features)
✅ Satisfies all test specifications
✅ No over-engineering
✅ Clean separation of concerns

## Next Agent

**Handoff to:** Verification Agent (Selective Tools)
**Task:** Validate GREEN phase and identify refactoring opportunities
```

> [!TIP]
> TDD discipline requires resisting the urge to add "nice-to-have" features during GREEN phase. The Implementation Agent added only what tests required: validation, parsing, transformation, and error handling. Features like caching, retries, or metrics belong in future cycles with corresponding tests.

### Phase 5: Verification Agent - GREEN Validation

The **Verification Agent** confirms all tests pass and performs code quality review to identify refactoring opportunities for the next phase.

**Agent Actions:**

1. `read_file` - Review `.copilot-handoffs/implementation-pipeline-002.md`
2. `run_in_terminal` - Execute `dotnet test` to confirm GREEN
3. `read_file` - Inspect `src/PipelineService.cs` for code quality
4. Analysis - Identify refactoring opportunities without breaking tests

**Generated Output:** `.copilot-handoffs/verification-pipeline-002.md`

```markdown
# Verification Report: PipelineService - GREEN Phase
**Agent:** Verification Agent (Selective Tools)
**Date:** 2025-11-23
**Status:** GREEN Phase Validated

## Test Execution Validation

**Result:** ✅ All 9 tests passing

```

Test Run Successful.
Total tests: 9
     Passed: 9
     Failed: 0
    Skipped: 0

```text

✅ No regressions introduced
✅ All acceptance criteria met
✅ Tests run successfully in isolation

## Implementation Review

### TDD Compliance
✅ **Minimal Implementation:** No unnecessary features added
✅ **Test-Driven:** Code satisfies exactly what tests specify
✅ **No Over-Engineering:** Simple, straightforward implementation

### Code Quality

**Strengths:**
- Clear dependency injection pattern
- Appropriate use of try-catch blocks
- Proper async/await usage
- Null checking before operations
- Meaningful error messages

**Structure:**
- Single responsibility (pipeline orchestration)
- Dependencies properly injected
- Error handling covers all test scenarios

## Refactoring Opportunities

The GREEN phase is complete, but the code would benefit from refactoring to improve maintainability without changing behavior:

### Priority: HIGH

#### #1 Extract Validation Logic
**Current:** Validation mixed with orchestration in ProcessDataAsync
**Improvement:** Extract to `ValidateIncomingEvent(IncomingEvent event)` private method
**Benefit:** Single responsibility, easier to test additional validation rules

#### #2 Extract Transformation Logic
**Current:** Inline object creation in ProcessDataAsync
**Improvement:** Extract to `TransformEvent(IncomingEvent incoming)` private method
**Benefit:** Clearer intent, reusable transformation logic

### Priority: MEDIUM

#### #3 Add XML Documentation
**Current:** No XML docs on public method
**Improvement:** Add `/// <summary>` documentation
**Benefit:** IntelliSense support, API discoverability

### Priority: LOW

#### #4 Consider Result Pattern Enhancement (OPTIONAL)
**Current:** Simple Result class with string errors
**Improvement:** Consider typed error results or error codes
**Benefit:** Structured error handling (only if future requirements demand it)

## Refactoring Priority

Recommend implementing refactorings #1-3 in REFACTOR phase.
Skip #4 unless specific requirement emerges (YAGNI principle).

## Status

**GREEN Phase:** ✅ Complete and Validated
**Tests:** ✅ All passing
**Code Quality:** ✅ Good, improvements identified
**Next Phase:** REFACTOR

## Next Agent

**Handoff to:** Implementation Agent (Full Tools)
**Task:** Apply refactoring improvements #1-3 while maintaining green tests
```

### Phase 6: Implementation Agent - REFACTOR Phase

The **Implementation Agent** applies the refactoring improvements identified by the Verification Agent. The critical rule: tests must remain green throughout refactoring.

**Agent Prompt:**

```markdown
Apply refactoring improvements from verification-pipeline-002.md (#1-3):
1. Extract validation logic to private method
2. Extract transformation logic to private method  
3. Add XML documentation

Run `dotnet test` after each change to ensure tests stay green.
```

**Refactored Code:** `src/PipelineService.cs`

```csharp
using System;
using System.Text.Json;
using System.Threading.Tasks;

public class PipelineService
{
    private readonly IQueueClient _queueClient;
    private readonly IStorageWriter _storageWriter;
    private readonly ILogger<PipelineService> _logger;

    public PipelineService(
        IQueueClient queueClient,
        IStorageWriter storageWriter,
        ILogger<PipelineService> logger)
    {
        _queueClient = queueClient;
        _storageWriter = storageWriter;
        _logger = logger;
    }

    /// <summary>
    /// Processes data from the queue by reading, validating, transforming, and storing events.
    /// </summary>
    /// <returns>A result indicating success or failure with error details.</returns>
    public async Task<Result> ProcessDataAsync()
    {
        try
        {
            var message = await _queueClient.ReadMessageAsync();
            var incomingEvent = ParseMessage(message);
            
            var validationError = ValidateIncomingEvent(incomingEvent);
            if (validationError != null)
            {
                return Result.Failure(validationError);
            }

            var processedEvent = TransformEvent(incomingEvent);

            try
            {
                await _storageWriter.WriteAsync(processedEvent);
            }
            catch (StorageException ex)
            {
                _logger.LogError(ex, "Storage write failed");
                return Result.Failure($"Storage error: {ex.Message}");
            }

            return Result.Success();
        }
        catch (QueueException)
        {
            throw;
        }
    }

    private IncomingEvent ParseMessage(string message)
    {
        if (string.IsNullOrEmpty(message))
        {
            _logger.LogWarning("Received null or empty message");
            throw new ValidationException("Message validation failed: null or empty");
        }

        try
        {
            return JsonSerializer.Deserialize<IncomingEvent>(message);
        }
        catch (JsonException ex)
        {
            _logger.LogError(ex, "Failed to parse message");
            throw new ValidationException($"Message parse error: {ex.Message}");
        }
    }

    private string ValidateIncomingEvent(IncomingEvent incomingEvent)
    {
        if (string.IsNullOrEmpty(incomingEvent?.EventType))
        {
            _logger.LogWarning("Missing required field: EventType");
            return "Validation error: EventType is required";
        }

        return null;
    }

    private ProcessedEvent TransformEvent(IncomingEvent incomingEvent)
    {
        return new ProcessedEvent
        {
            EventType = incomingEvent.EventType,
            UserId = incomingEvent.UserId,
            ProcessedAt = DateTime.UtcNow,
            OriginalTimestamp = incomingEvent.Timestamp
        };
    }
}

public class IncomingEvent
{
    public string EventType { get; set; }
    public int UserId { get; set; }
    public string Timestamp { get; set; }
    public string Data { get; set; }
}

public class ProcessedEvent
{
    public string EventType { get; set; }
    public int UserId { get; set; }
    public DateTime ProcessedAt { get; set; }
    public string OriginalTimestamp { get; set; }
}

public class Result
{
    public bool IsSuccess { get; private set; }
    public string Error { get; private set; }

    public static Result Success() => new Result { IsSuccess = true };
    public static Result Failure(string error) => new Result { IsSuccess = false, Error = error };
}

public class ValidationException : Exception
{
    public ValidationException(string message) : base(message) { }
}
```

**Test Execution After Refactoring:**

```bash
$ dotnet test

✅ PASS: 9 tests passed (no changes to test results)
- All tests remain green after refactoring
```

**Generated Output:** `.copilot-handoffs/implementation-pipeline-003.md`

```markdown
# Implementation Handoff: PipelineService - REFACTOR Phase
**Agent:** Implementation Agent (Full Tools)
**Date:** 2025-11-23
**Status:** REFACTOR Phase Complete

## Refactoring Actions Applied

### ✅ Refactoring #1: Extract Validation Logic
- Created `ValidateIncomingEvent(IncomingEvent)` private method
- Returns validation error string or null
- Isolated validation rules from orchestration logic

### ✅ Refactoring #2: Extract Transformation Logic
- Created `TransformEvent(IncomingEvent)` private method
- Returns ProcessedEvent
- Encapsulates transformation rules

### ✅ Refactoring #3: Extract Message Parsing
- Created `ParseMessage(string)` private method (bonus improvement)
- Handles null/empty checks and JSON parsing
- Throws ValidationException for parse/validation errors

### ✅ Refactoring #4: Add XML Documentation
- Added `<summary>` documentation to ProcessDataAsync
- Describes method purpose and return value

## Code Improvements

**Before Refactoring:** 50 lines, single method with mixed concerns
**After Refactoring:** 60 lines, 4 methods with clear responsibilities

**Method Responsibilities:**
- `ProcessDataAsync` - Orchestrates pipeline flow
- `ParseMessage` - Message parsing and initial validation
- `ValidateIncomingEvent` - Business rule validation
- `TransformEvent` - Data transformation

## Test Results

✅ All 9 tests passing after refactoring
✅ No behavior changes
✅ No test modifications needed

## Benefits Achieved

1. **Readability:** ProcessDataAsync now reads like a workflow
2. **Maintainability:** Each method has single responsibility
3. **Extensibility:** Easy to add validation rules or transformations
4. **Testability:** Individual methods could be unit tested if needed

## RED-GREEN-REFACTOR Cycle Complete

✅ **RED:** Tests written and failing (Phase 2)
✅ **GREEN:** Implementation makes tests pass (Phase 4)
✅ **REFACTOR:** Code improved without breaking tests (Phase 6)

## Agent Coordination Summary

- **Test Design Agent** - Created specifications (read-only)
- **Implementation Agent** - Created tests (RED), implementation (GREEN), refactoring (REFACTOR)
- **Verification Agent** - Validated RED/GREEN phases, identified improvements

**Total Handoffs:** 5 documents across 6 phases
**Agent Transitions:** 6 handoffs maintaining context
```

> [!NOTE]
> This completes one RED-GREEN-REFACTOR cycle with agent coordination. For multiple cycles continuing this workflow including parallel test development, integration testing coordination, and production deployment patterns, see Part III, Chapter 14 case studies demonstrating 6-8 complete cycles with custom agent handoffs.

## Agent Handoff Patterns in TDD

Agent handoffs enable specialization by constraining tool access at each phase. The Test Design Agent focuses on specifications without implementation concerns, the Implementation Agent writes code guided by validated specs, and the Verification Agent ensures quality gates before advancing.

### Handoff Transition: Test Design → Implementation

The Test Design Agent produces `.copilot-handoffs/test-design-NNN.md` documents containing test specifications with explicit acceptance criteria. These documents bridge agent transitions without requiring the Implementation Agent to research the problem space again.

**Effective handoff document structure:**

```markdown
# Test Design Specification: [Feature Name]
**Agent:** Test Design Agent (Read-Only)
**Date:** 2025-11-24
**Status:** Test Specifications Complete

## Test Specifications

### Test 1: [Given_When_Then_Name]
**Acceptance Criteria:**
- [ ] Specific, measurable criterion 1
- [ ] Specific, measurable criterion 2
- [ ] Specific, measurable criterion 3

## Next Agent

**Handoff to:** Implementation Agent (Full Tools)
**Task:** Implement failing tests based on these specifications
**Expected Output:** Complete test class with N test methods
```

The checkbox format enables the Verification Agent to validate implementation completeness. Vague criteria like "☐ Service works correctly" prevent effective validation, while specific criteria like "☐ ProcessDataAsync returns null for empty queue" and "☐ Throws FormatException for invalid JSON" enable precise verification.

### Handoff Transition: Implementation → Verification

The Implementation Agent produces `.copilot-handoffs/implementation-NNN.md` documents after RED, GREEN, and REFACTOR phases. These documents include test execution results and code change summaries.

**Implementation handoff example:**

```markdown
# Implementation Handoff: [Feature] - RED Phase
**Agent:** Implementation Agent (Full Tools)
**Date:** 2025-11-24
**Status:** RED Phase Complete

## Actions Taken

1. Created `tests/FeatureTests.cs` with N test methods
2. Implemented test specifications from test-design-NNN.md
3. Used [mocking library] for dependencies

## RED Phase Validation

✅ All tests fail with expected error: "[Type/Method] not found"
✅ No test bugs detected
✅ Tests are independent and isolated

## Next Agent

**Handoff to:** Verification Agent (Selective Tools)
**Task:** Validate RED phase completion and test quality
```

The Verification Agent reviews this document, executes tests to confirm the failure state, and produces `.copilot-handoffs/verification-NNN.md` with quality assessments and recommendations.

### Handoff Transition: Verification → Next Cycle

The Verification Agent identifies quality issues or improvement opportunities that feed back into the next cycle. After validating the REFACTOR phase, the agent signals completion or identifies gaps requiring additional test design work.

**Verification output triggering new cycle:**

```markdown
# Verification Report: [Feature] - REFACTOR Phase
**Status:** REFACTOR Phase Validated

## Identified Gaps

**Missing Coverage:**
- Concurrent access scenarios not tested
- Error recovery paths incomplete

## Recommendations

**Next Cycle Focus:**
- Add thread safety tests
- Implement retry logic with exponential backoff

## Next Agent

**Handoff to:** Test Design Agent (Read-Only)
**Task:** Create specifications for concurrent access and retry behavior
```

This feedback loop ensures continuous improvement through multiple TDD cycles while maintaining clear agent coordination.

> [!NOTE]
> Agent handoff coordination adds ~5-10 minutes per cycle for handoff document creation and review. This overhead is typically offset by ~15-20 minutes saved through earlier defect detection and reduced debugging time. For production Beads workflows with multiple cycles and advanced coordination patterns including parallel agent execution and dependency management, see Part III, Chapter 14.

## TDD with AI Benefits

AI-assisted TDD accelerates development while maintaining quality. Edit Mode helps you complete TDD cycles faster without sacrificing control.

**Typical cycle times:**

Traditional TDD without AI often takes 35-60 minutes per cycle, though times vary significantly by complexity and experience. Writing tests manually typically requires 10-15 minutes, implementation takes 15-30 minutes, and refactoring adds another 10-15 minutes.

AI-assisted TDD with Edit Mode can reduce cycles to 11-25 minutes for straightforward features. AI proposes tests for your review in 3-5 minutes, implements solutions you approve in 5-10 minutes, and suggests refactorings you validate in 3-5 minutes, with experienced users achieving faster times.

**Agent coordination with specialized roles:**

Multiple agents with constrained tools add coordination overhead but provide significant quality advantages. The Test Design Agent focuses purely on comprehensive test coverage without implementation distractions. The Implementation Agent follows validated specifications without researching requirements. The Verification Agent ensures quality gates before advancing phases.

Agent coordination typically adds ~5-10 minutes per cycle for handoff document creation and review. However, this overhead is usually offset by ~15-20 minutes saved through earlier defect detection, reduced debugging time, and fewer implementation mistakes. The specialization enables each agent to focus on its core strength without context-switching between research, implementation, and validation concerns.

**Significant quality benefits beyond speed:**

* AI suggests comprehensive test cases you might overlook
* AI enforces testing patterns consistently across your codebase
* You maintain complete control through review of each step
* Tests document code intent clearly for future developers
* Specialized agents prevent common TDD mistakes through tool constraints

## TDD Anti-Patterns with AI

Avoid these common mistakes when combining AI with TDD.

### Anti-Pattern 1: Using Agent Mode for TDD

Agent Mode undermines TDD discipline by implementing tests and code together.

**Problem example:**

```markdown
Agent Mode prompt: "Implement shopping cart with TDD"

Agent writes tests and implementation simultaneously.
Tests may be written after implementation to match what exists.
TDD discipline is lost completely.
```

**Solution:**

Use Edit Mode with explicit phase instructions. Start with "RED: write failing test first" and wait for your review. Then request "GREEN: implement to pass test" and review the implementation. Finally ask for "REFACTOR: improve code" and validate the changes.

### Anti-Pattern 2: Skipping RED Phase

Skipping the RED phase prevents you from validating that tests actually work.

**Problem example:**

```markdown
Edit Mode: "Write test that passes immediately"

AI writes test and implementation together.
No verification that test fails first.
Test might not actually validate anything.
```

**Solution:**

Always write the failing test first. Run the test to verify it fails with the expected error message. Only then proceed to implementation. This confirms your test checks the right behavior.

### Anti-Pattern 3: Over-Implementation in GREEN Phase

Over-implementing during the GREEN phase adds untested code.

**Problem example:**

AI implements extra features beyond test requirements. Tests pass but code does more than what tests validate. Future changes might break untested functionality.

**Solution:**

Review AI implementations carefully and ask "Does this do more than make the test pass?" Request minimal implementations that satisfy only current test requirements. Defer extra features to future TDD cycles with their own tests.

### Anti-Pattern 4: Unclear Agent Handoffs

Vague acceptance criteria in handoff documents prevent effective verification and create implementation ambiguity.

**Problem example:**

```markdown
# Test Design Specification

### Test 1: Service Processes Data
**Acceptance Criteria:**
- [ ] Service works correctly
- [ ] Errors are handled
- [ ] Performance is acceptable
```

The Implementation Agent cannot determine what "works correctly" means. The Verification Agent cannot validate "acceptable" performance without specific thresholds.

**Solution:**

Write explicit, measurable acceptance criteria with specific expected behaviors:

```markdown
### Test 1: Given_ValidMessage_When_ProcessDataAsync_Then_WritesToStorage
**Acceptance Criteria:**
- [ ] ProcessDataAsync returns null for empty queue
- [ ] Throws FormatException for invalid JSON
- [ ] Validates EventType field presence
- [ ] Calls storageWriter.WriteAsync exactly once
- [ ] Returns success result with processed event ID
```

Each criterion is verifiable through test assertions. The Implementation Agent knows exactly what to test, and the Verification Agent can confirm each criterion with checkbox validation.

> [!NOTE]
> Agent coordination overhead (~5-10 minutes per handoff) is worthwhile when working on complex features requiring comprehensive test coverage. For simple features or exploratory work, single-agent Edit Mode may be more efficient. Choose the approach matching your quality requirements and time constraints.

---

**Previous:** [Complex Workflow: Merge Conflicts](./05-complex-workflow-merge-conflicts.md) | **Next:** [Complex Workflow: Large Refactoring](./07-complex-workflow-large-refactoring.md)

<!-- markdownlint-disable MD036 -->
*🤖 Crafted with precision by ✨Copilot following brilliant human instruction,
then carefully refined by our team of discerning human reviewers.*
<!-- markdownlint-enable MD036 -->
