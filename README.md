# 🚀 Nome do Projeto

Descrição curta sobre o projeto. Aplicação **Java Spring Boot** de propósito geral, estruturada com **Arquitetura Hexagonal** e **DDD (Domain-Driven Design)**.

---

## 🛠 Tecnologias

- ☕ Java 25
- 🌱 Spring Boot 4.x.x
- ⚙️ Gradle
- 🧪 JUnit 5 / Mockito
- 🐳 Docker (opcional)
- 🗄 H2 Database (opcional)

---

## 🏗 Arquitetura

### 🧩 Hexagonal (Ports & Adapters)

A aplicação segue o padrão hexagonal, separando:

- **Domain**: Entidades, agregados e regras de negócio.
- **Application**: Casos de uso e serviços de aplicação.
- **Infrastructure**:
  - **Adapters**:
      - **In**: REST Controllers, GraphQL, CLI
      - **Out**: Repositórios, integração com APIs externas
  - **Config**: Beans e configurações gerais do Spring  

[Controllers / API] -> [Application / Services] -> [Domain / Entities]
| ^
v |
[External Adapters / Repositories] -----


### 📚 DDD (Domain-Driven Design)

- **Entities**: Objetos com identidade.
- **Value Objects**: Objetos imutáveis sem identidade própria.
- **Aggregates**: Conjunto de entidades com uma raiz.
- **Repositories**: Persistência abstrata.
- **Services**: Lógica de negócio que não pertence a uma entidade.

---

## 📂 Estrutura de Pastas
```
src/
├── main/
│ ├── java/
│ │ └── com/seuprojeto/
│ │   ├── domain/ # 🧬 Entidades e regras de negócio
│ │   ├── application/ # ⚙️ Casos de uso e serviços
│ │   └── infrastructure/
│ │     ├── adapters/
│ │     │  ├── in/ # 🌐 Controllers, APIs
│ │     │  └── out/ # 🔌 Repositórios, integrações externas
│ │     └── config/ # ⚙️ Beans e configurações do Spring
│ └── resources/ # 📁 Configurações, arquivos estáticos
└── test/
└── java/
└── com/seuprojeto/ # 🧪 Testes unitários e de integração
```

---

## 🏗 Como Compilar

```bash
./gradlew clean build
```

Windows:
```
gradlew.bat clean build
```
O .jar será gerado em build/libs.

▶️ Como Rodar
```
java -jar build/libs/nome-do-projeto-0.0.1-SNAPSHOT.jar
```

💡 Usando Docker:
```
docker build -t nome-do-projeto .
docker run -p 8080:8080 nome-do-projeto
```

🧪 Como Testar

Executar testes unitários e de integração:
```
./gradlew test
```
Relatórios estarão em build/reports/tests/test/index.html.

🚀 Como Implantar

1. Configurar variáveis de ambiente ou application.yml para banco, portas, etc.

2. Gerar o .jar via Gradle

3. Subir em servidor (Linux, Docker, Kubernetes, etc.):

```
scp build/libs/nome-do-projeto-0.0.1-SNAPSHOT.jar user@server:/app/
ssh user@server
java -jar /app/nome-do-projeto-0.0.1-SNAPSHOT.jar
```

Monitorar logs:

```
tail -f /app/logs/application.log
```

🤝 Contribuição

1. Fork do projeto
2. Criar branch feature/nome-da-feature
3. Commit e push
4. Abrir Pull Request

📄 Licença

MIT