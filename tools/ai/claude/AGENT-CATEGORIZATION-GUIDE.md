# Agent Categorization Guide
## Clear Criteria for Agent Organization

---

## Category Definitions

### 01-core: Fundamental Development Agents
**Criteria**: Basic development tasks that are language/framework agnostic
- Code review
- Debugging (general)
- API design (general)
- Documentation (general)
- UI/UX design
**Examples**: code-reviewer, debugger, api-architect, ui-designer

### 02-orchestration: Multi-Agent Coordination
**Criteria**: Agents that coordinate other agents or analyze projects at a high level
- Multi-agent orchestration
- Project analysis
- Team configuration
**Examples**: tech-lead-orchestrator, project-analyst, team-configurator

### 03-languages: Programming Language Specialists
**Criteria**: Agents specialized in a specific programming language
- Language syntax expertise
- Language-specific patterns
- Language ecosystem knowledge
**Examples**: python-specialist, javascript-pro, rust-pro, golang-pro

### 04-frameworks: Framework/Library Specialists
**Criteria**: Agents specialized in specific frameworks or libraries
- Framework-specific patterns
- Framework APIs and conventions
- Framework ecosystem
**Examples**: react-component-architect, django-backend-expert, rails-api-developer

### 05-architecture: System Architecture & Design
**Criteria**: Agents focused on system design and architecture
- System architecture
- Database design
- Cloud architecture
- Infrastructure design
**Examples**: backend-architect, database-architect, cloud-architect

### 06-specialists: Domain/Task Specialists
**Criteria**: Agents specialized in specific domains or complex tasks
- AI/ML engineering
- Security
- Performance engineering
- Error analysis
- Network engineering
**Examples**: ai-ml-engineer, security-specialist, error-detective, network-engineer

### 07-devops: DevOps & Infrastructure
**Criteria**: Agents focused on deployment, infrastructure, and operations
- CI/CD
- Infrastructure as Code
- Deployment
- Monitoring
**Examples**: deployment-engineer, terraform-specialist, infrastructure-ops-specialist

### 08-testing: Testing & Quality Assurance
**Criteria**: Agents focused on testing and quality
- Test automation
- Performance testing
- API testing
- Test analysis
**Examples**: test-automation-specialist, api-test-specialist, performance-analyst

### 09-documentation: Documentation & Education
**Criteria**: Agents focused on creating documentation and educational content
- API documentation
- Tutorial creation
- Reference documentation
**Examples**: api-documenter, tutorial-engineer, reference-builder, documentation-specialist

### 10-data: Data & Analytics
**Criteria**: Agents focused on data processing and analytics
- Data engineering
- Data analysis
- Quantitative analysis
**Examples**: data-engineering-specialist, quant-analyst

### 11-optimization: Optimization & Improvement
**Criteria**: Agents focused on optimization
- Performance optimization
- Developer experience
- Prompt engineering
- Code optimization
**Examples**: performance-optimizer, dx-optimizer, prompt-engineer

### 12-learning: Learning & Knowledge Management
**Criteria**: Agents focused on learning extraction and knowledge management
- Lesson extraction
- Pattern propagation
- Memory management
**Examples**: lesson-extractor, pattern-propagator, memory-bank-synchronizer

---

## Reorganization Plan

### Agents to Move

#### From 05-engineering to 03-languages:
- python-specialist → 03-languages

#### From 05-engineering to 05-architecture:
- backend-architect (stays/renamed category)
- database-architect (stays/renamed category)
- cloud-architect (stays/renamed category)

#### From 05-engineering to 06-specialists:
- ai-ml-engineer
- security-specialist
- error-detective
- network-engineer
- frontend-specialist
- legacy-modernizer
- context-manager

#### From 05-engineering to 07-devops:
- deployment-engineer
- terraform-specialist

#### From 05-engineering to 08-testing:
- test-automation-specialist

#### From 05-engineering to 09-documentation:
- api-documenter
- tutorial-engineer
- reference-builder

#### From 01-core split:
- debugger → 01-core (stays - general debugging)
- code-archaeologist → 06-specialists (specialized analysis)
- ui-designer → 01-core (stays - general UI)

#### From 04-frameworks clarification:
- Keep all framework-specific agents
- tailwind-css-expert might move to 06-specialists (CSS specialist)

---

## Final Structure

```
.claude/agents/
├── 01-core/          # General development (code-reviewer, debugger, api-architect)
├── 02-orchestration/ # Multi-agent coordination
├── 03-languages/     # Language specialists (python, js, rust, etc.)
├── 04-frameworks/    # Framework specialists (react, django, rails)
├── 05-architecture/  # System design (backend, database, cloud architects)
├── 06-specialists/   # Domain experts (ai-ml, security, error-detective)
├── 07-devops/        # DevOps & infrastructure
├── 08-testing/       # Testing & QA
├── 09-documentation/ # Documentation & education
├── 10-data/          # Data & analytics
├── 11-optimization/  # Performance & optimization
└── 12-learning/      # Learning & knowledge extraction
```

---

## Decision Rules

When categorizing an agent, ask:
1. **Is it language-specific?** → 03-languages
2. **Is it framework-specific?** → 04-frameworks
3. **Is it about system design?** → 05-architecture
4. **Is it a specialized domain?** → 06-specialists
5. **Is it about deployment/infrastructure?** → 07-devops
6. **Is it about testing?** → 08-testing
7. **Is it about documentation?** → 09-documentation
8. **Is it about data processing?** → 10-data
9. **Is it about optimization?** → 11-optimization
10. **Is it about learning/knowledge?** → 12-learning
11. **Otherwise, is it fundamental?** → 01-core

---

*Last Updated: 2025-01-21*
