# ADR-001 — Organização do Código por Feature (Feature-First)

## Status
Aceito

## Contexto
A aplicação é desenvolvida em Java com Spring Boot e possui múltiplas capacidades
de negócio, com crescimento contínuo do código e do time.

Historicamente, a organização por camadas técnicas (`controller`, `service`,
`repository`, etc.) tende a gerar os seguintes problemas:

- Forte acoplamento entre partes não relacionadas do sistema
- Dificuldade de entender o impacto de mudanças em uma funcionalidade específica
- Código espalhado por múltiplos pacotes para uma única feature
- Baixa coesão e alto custo de manutenção
- Evolução difícil para modularização ou extração de serviços

Além disso, o projeto adota princípios de:
- Arquitetura Hexagonal
- Modularidade explícita (Spring Modulith)

O que exige limites claros e bem definidos.

## Decisão
O projeto adotará **organização por feature (feature-first)** como padrão estrutural.

Cada feature representa uma **capacidade de negócio** e conterá internamente
suas próprias camadas, seguindo princípios hexagonais.

Estrutura padrão por feature:
```
<feature>/
├─ domain
├─ application
└─ adapter
├─ inbound
└─ outbound
```

Exemplo:
```
order/
├─ domain
├─ application
└─ adapter
```

Pacotes transversais de infraestrutura técnica permanecem fora das features.

## Justificativa
- Features representam melhor o domínio do negócio do que camadas técnicas
- Aumenta a coesão e reduz o acoplamento entre partes não relacionadas
- Facilita entendimento, manutenção e evolução do sistema
- Alinha-se naturalmente com:
    - Arquitetura Hexagonal
    - Modular Monolith
    - Spring Modulith
- Facilita futura extração de features para microserviços, se necessário
- Evita o antipadrão de “pastas técnicas gigantes” (`service`, `repository`, etc.)

## Consequências

### Positivas
- Código de cada feature fica concentrado em um único local
- Mudanças têm escopo mais claro
- Reduz conflitos entre desenvolvedores
- Facilita testes, refatorações e isolamento
- Estrutura reflete o negócio, não o framework

### Negativas
- Pode causar estranhamento inicial para quem vem de MVC tradicional
- Requer disciplina para não criar features excessivamente pequenas ou artificiais
- Exige documentação clara para novos membros do time

## Regra adotada no projeto
- Organização principal do código é **por feature**
- Camadas técnicas são internas à feature
- Camadas transversais puramente técnicas ficam fora das features
- Novas funcionalidades DEVEM ser criadas como novas features,
  e não como extensões de pacotes técnicos globais

## Observação
Arquitetura e organização de código devem refletir o **domínio e as capacidades
do sistema**, não a estrutura do framework utilizado.

# ADR-002 — Infraestrutura não é modelada como Application Module

## Status
Aceito

## Contexto
A aplicação utiliza:
- organização **feature-first**
- princípios de **Arquitetura Hexagonal**
- **Spring Modulith** para definição de limites entre módulos

Cada feature representa uma capacidade de negócio e possui seus próprios pacotes
`domain`, `application` e `adapter`.

Existe também um pacote `infrastructure`, que concentra preocupações técnicas
transversais como:
- configuração de persistência (JPA, transações)
- clientes HTTP base
- mensageria
- segurança
- observabilidade

Surgiu a dúvida se esse pacote `infrastructure` deveria ser tratado como um
`@ApplicationModule`, assim como as features.

## Decisão
O pacote `infrastructure` **NÃO será modelado como um Application Module**.

Apenas pacotes que representam **capacidades de negócio** serão definidos como
módulos no Spring Modulith.

O pacote `infrastructure` será tratado como **suporte técnico transversal**,
utilizado pelas features, sem representar um boundary de negócio.

## Justificativa
- Módulos no Spring Modulith representam **bounded contexts ou capacidades**
- Infraestrutura não possui significado de negócio
- Tratar infraestrutura como módulo:
    - aumenta rigidez sem ganho proporcional
    - eleva o custo cognitivo do time
    - confunde conceito técnico com conceito de domínio
- Infraestrutura dificilmente faria sentido como unidade independente em uma
  eventual extração para microserviços

## Consequências

### Positivas
- Estrutura mais simples e pragmática
- Menos anotações e regras artificiais
- Módulos refletem o domínio, não a tecnologia
- Facilita onboarding de novos desenvolvedores

### Negativas
- Dependências para infraestrutura não são explicitamente controladas pelo Modulith
- Requer disciplina para evitar vazamento de regras de negócio para a infra

## Regra adotada no projeto
- **Features de negócio** → `@ApplicationModule`
- **Infraestrutura técnica** → pacote de suporte, sem `@ApplicationModule`

## Observação
Arquitetura hexagonal define **direção de dependências**, não organização física
de pacotes. Esta decisão prioriza clareza e manutenção no longo prazo.

# ADR-003 — Uso de Arquitetura Hexagonal Dentro das Features

## Status
Aceito

## Contexto
O projeto adota organização **feature-first**, onde cada feature representa uma
capacidade de negócio clara.

Dentro de cada feature, existe a necessidade de:
- isolar regras de negócio de detalhes técnicos
- permitir testes sem dependência de infraestrutura
- facilitar evolução tecnológica sem impacto no domínio
- manter o código legível e sustentável no longo prazo

Arquiteturas tradicionais baseadas em camadas técnicas globais (MVC) tendem a
acoplar regras de negócio a frameworks, dificultando manutenção e evolução.

Dado esse cenário, foi avaliado o uso da **Arquitetura Hexagonal (Ports & Adapters)**
como padrão interno para cada feature.

## Decisão
Cada feature do projeto adotará **Arquitetura Hexagonal internamente**.

A organização interna padrão de uma feature será:
```
<feature>/
├─ domain
├─ application
└─ adapter
├─ inbound
└─ outbound
```

### Responsabilidades por camada

#### Domain
- Entidades, Value Objects e regras de negócio
- Interfaces que representam dependências do domínio (ex: Repositories)
- NÃO conhece:
    - Spring
    - JPA
    - HTTP
    - Mensageria
    - Infraestrutura

#### Application
- Casos de uso (use cases)
- Orquestração de fluxos
- Consome o domain e seus contratos
- Define ports para integrações externas quando necessário

#### Adapter
- Implementações técnicas
- Conversão entre modelos externos e internos
- Divide-se em:
    - **Inbound**: controllers, listeners, consumers
    - **Outbound**: persistência, APIs externas, mensageria

## Justificativa
- Hexagonal isola o domínio de detalhes técnicos
- Facilita testes unitários e de integração
- Reduz impacto de mudanças tecnológicas
- Mantém o domínio expressivo e independente
- Funciona bem em conjunto com feature-first e Spring Modulith
- Evita dependência direta do domain em frameworks

## Consequências

### Positivas
- Domínio mais limpo e testável
- Menor acoplamento com infraestrutura
- Features evoluem de forma independente
- Melhor separação de responsabilidades
- Facilita futura migração para microserviços

### Negativas
- Mais código e estrutura inicial
- Curva de aprendizado para novos membros do time
- Requer disciplina para não criar abstrações desnecessárias

## Regras adotadas no projeto
- Domain NÃO pode depender de:
    - Spring
    - Infraestrutura
- Application NÃO contém lógica de persistência ou tecnologia
- Adapters são responsáveis por conversão e integração
- Frameworks ficam sempre na borda
- Não criar ports ou adapters sem necessidade real

## Observação
Arquitetura Hexagonal não é um fim em si mesma, mas um meio para
atingir clareza, testabilidade e evolução sustentável do sistema.
