# Claude Code Agents for AI Middleware

This document describes the specialized agents available for the AI middleware project. These agents have been curated specifically for Azure Functions-based Python development with Redis, Service Bus, and AI/LLM integration.

## Available Agents

### Engineering Agents (19)

#### **ai-ml-engineer**
- **Purpose**: AI/ML implementation, LLM integration, prompt engineering
- **Use Cases**:
  - Implementing LiteLLM/OpenAI integrations
  - Optimizing prompts for cost and quality
  - Building intelligent routing and caching systems
  - Designing AI pipelines for document processing

#### **api-documenter**
- **Purpose**: Create OpenAPI specs, generate SDKs, write API documentation
- **Use Cases**:
  - Documenting Azure Functions endpoints
  - Creating API contracts for middleware services
  - Generating client libraries for API consumers

#### **architect-reviewer**
- **Purpose**: Review architecture patterns, SOLID principles, system design
- **Use Cases**:
  - Reviewing microservices architecture
  - Evaluating Redis-first storage patterns
  - Assessing async processing patterns
  - Checking dependency management

#### **backend-architect**
- **Purpose**: Design RESTful APIs, microservice boundaries, system architecture
- **Use Cases**:
  - Designing Azure Functions endpoints
  - Planning Service Bus message schemas
  - Creating microservice boundaries
  - System architecture decisions

#### **database-architect**
- **Purpose**: Database schema design, query optimization, data modeling
- **Use Cases**:
  - Designing efficient database schemas
  - Optimizing Redis key patterns
  - Query performance tuning
  - Choosing between SQL and NoSQL solutions

#### **cloud-architect**
- **Purpose**: Design Azure infrastructure, optimize cloud costs, scaling strategies
- **Use Cases**:
  - Planning Azure Functions deployment
  - Designing multi-region deployments
  - Implementing auto-scaling strategies
  - Optimizing Azure resource costs

#### **code-reviewer**
- **Purpose**: Comprehensive code quality review, security analysis, best practices
- **Use Cases**:
  - Reviewing Python code quality
  - Checking async/await patterns
  - Security vulnerability assessment
  - Performance optimization suggestions

#### **context-manager**
- **Purpose**: Manage context across long-running tasks and AI operations
- **Use Cases**:
  - Managing LLM context windows
  - Handling session context accumulation
  - Coordinating multi-step AI workflows

#### **debugger**
- **Purpose**: Debug errors, test failures, and unexpected behavior
- **Use Cases**:
  - Troubleshooting async operation issues
  - Debugging Redis connection problems
  - Fixing Service Bus message processing
  - Resolving Azure Functions runtime errors

#### **deployment-engineer**
- **Purpose**: Configure CI/CD pipelines, Docker containers, deployments
- **Use Cases**:
  - Setting up Azure DevOps pipelines
  - Configuring Docker containers
  - Managing Azure Functions deployments
  - Implementing blue-green deployments

#### **network-engineer**
- **Purpose**: Debug connectivity, configure load balancers, network security
- **Use Cases**:
  - Troubleshooting Redis connectivity
  - Configuring Service Bus networking
  - Setting up SSL/TLS for Azure Functions
  - Debugging timeout issues

#### **python-specialist**
- **Purpose**: Write idiomatic Python with advanced features, optimization
- **Use Cases**:
  - Implementing async/await patterns
  - Optimizing Python performance
  - Using Python 3.12 features
  - Writing comprehensive tests

#### **terraform-specialist**
- **Purpose**: Write Terraform modules, manage state, implement IaC
- **Use Cases**:
  - Creating Azure infrastructure modules
  - Managing Terraform state files
  - Implementing infrastructure automation
  - Handling multi-environment deployments

#### **test-automation-specialist**
- **Purpose**: Write tests, fix failing tests, maintain test suite health
- **Use Cases**:
  - Writing E2E tests for Azure Functions
  - Creating integration tests for Redis/Service Bus
  - Fixing test failures after code changes
  - Improving test coverage

#### **data-engineering-specialist**
- **Purpose**: Redis optimization, ETL pipelines, data processing
- **Use Cases**:
  - Optimizing Redis operations and key patterns
  - Building data transformation pipelines
  - JSON parsing and document processing
  - Implementing caching strategies

#### **security-specialist**
- **Purpose**: Security analysis, vulnerability assessment, auth implementation
- **Use Cases**:
  - LLM prompt injection prevention
  - OWASP API security for financial data
  - Azure security compliance
  - Redis data protection strategies

#### **frontend-specialist**
- **Purpose**: Complex frontend architectures, advanced React/Vue/Angular
- **Use Cases**:
  - Micro-frontend architectures
  - Performance-critical UI optimization
  - Complex state management patterns
  - Large-scale frontend systems

#### **ui-designer**
- **Purpose**: UI/UX design, component design systems
- **Use Cases**:
  - Creating design systems
  - Building reusable component libraries
  - Improving visual aesthetics
  - Rapid prototyping for 6-day sprints

### Operations Agents (1)

#### **infrastructure-ops-specialist**
- **Purpose**: Monitor system health, manage scaling, ensure reliability
- **Use Cases**:
  - Monitoring Azure resource health
  - Managing Redis performance
  - Optimizing Service Bus throughput
  - Implementing disaster recovery

### Testing Agents (4)

#### **api-test-specialist**
- **Purpose**: API performance testing, contract testing, load testing
- **Use Cases**:
  - Testing Azure Functions endpoints
  - Validating API contracts
  - Performance benchmarking
  - Load testing with realistic scenarios

#### **performance-analyst**
- **Purpose**: Performance testing, profiling, optimization recommendations
- **Use Cases**:
  - Benchmarking Redis operations
  - Measuring JSON serialization performance
  - Testing concurrent request handling
  - Identifying bottlenecks

#### **test-results-analyzer**
- **Purpose**: Analyze test results, identify trends, generate reports
- **Use Cases**:
  - Analyzing E2E test results
  - Tracking test suite health over time
  - Identifying flaky tests
  - Generating quality metrics

#### **workflow-optimizer**
- **Purpose**: Optimize development workflows, CI/CD efficiency
- **Use Cases**:
  - Optimizing E2E test execution
  - Improving Docker build times
  - Streamlining deployment processes
  - Enhancing developer productivity

## Usage Guidelines

### When to Use Each Agent

1. **Starting a new feature**: Use `backend-architect` to design, then `python-specialist` to implement
2. **Debugging issues**: Start with `debugger`, may need `network-engineer` for connectivity
3. **Performance problems**: Use `performance-analyst` then `python-specialist` for optimization
4. **Code review**: Use `code-reviewer` for security and quality, `architect-reviewer` for design
5. **Testing**: Use `test-automation-specialist` for tests, `api-test-specialist` for endpoint validation
6. **Deployment**: Use `deployment-engineer` for CI/CD, `terraform-specialist` for infrastructure
7. **AI features**: Use `ai-ml-engineer` for LLM integration and optimization

### Best Practices

1. **Use agents proactively** - Don't wait for problems to occur
2. **Combine agents** - Use multiple agents for comprehensive analysis
3. **Follow E2E-first approach** - Align with the testing philosophy in CLAUDE.md
4. **Focus on async patterns** - This is an async-first codebase
5. **Consider Redis patterns** - Redis is the primary storage mechanism

## Integration with AI Middleware

These agents are specifically configured to work with:
- **Azure Functions** Python runtime
- **Redis** for caching and session storage
- **Azure Service Bus** for message queuing
- **LiteLLM/OpenAI** for AI processing
- **Docker** for local development
- **Terraform** for infrastructure as code
- **E2E testing** as primary validation

## Settings Configuration

The `.claude/settings.json` has been configured with appropriate permissions:
- **Allowed**: Docker, Redis CLI, Azure CLI, Terraform, E2E test scripts
- **Tools**: Ruff (linting), Pyright (type checking), Pytest (testing)
- **Removed**: Django, Flask, and other irrelevant frameworks

## Maintenance

This agent list is maintained to align with the AI middleware requirements. Agents focused on:
- Game development
- Mobile applications  
- Frontend development
- Generic business operations

Have been removed to maintain focus on enterprise AI middleware development.
