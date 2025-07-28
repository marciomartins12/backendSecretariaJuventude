# Crono Juventude - Backend

Backend para o sistema de controle de ponto da Crono Juventude.

## Tecnologias Utilizadas

- **Node.js** + **TypeScript**
- **Express.js** (Framework web)
- **Prisma** (ORM)
- **MySQL** (Banco de dados)
- **JWT** (Autenticação)
- **bcryptjs** (Hash de senhas)
- **Zod** (Validação de dados)

## Configuração do Ambiente

### 1. Instalar Dependências

```bash
cd backend
npm install
```

### 2. Configurar Banco de Dados

1. Crie um banco MySQL chamado `crono_juventude`
2. Copie o arquivo `.env.example` para `.env`
3. Configure a string de conexão do banco:

```env
DATABASE_URL="mysql://username:password@localhost:3306/crono_juventude"
JWT_SECRET="seu_jwt_secret_super_seguro_aqui"
PORT=3001
NODE_ENV=development
FRONTEND_URL="http://localhost:5173"
```

### 3. Executar Migrações

```bash
# Gerar cliente Prisma
npm run prisma:generate

# Sincronizar banco com schema
npm run prisma:push
```

### 4. Iniciar Servidor

```bash
# Desenvolvimento (com hot reload)
npm run dev

# Produção
npm run build
npm start
```

## Estrutura da API

### Autenticação

- `POST /api/auth/login` - Login do usuário

**Usuário padrão:**
- Username: `admin`
- Password: `admin123`

### Funcionários

- `GET /api/employees` - Listar funcionários
- `GET /api/employees/:id` - Buscar funcionário por ID
- `GET /api/employees/scheduled-today` - Funcionários escalados hoje
- `POST /api/employees` - Criar funcionário
- `PUT /api/employees/:id` - Atualizar funcionário
- `DELETE /api/employees/:id` - Excluir funcionário

### Registros de Ponto

- `GET /api/time-records` - Listar registros (com filtros)
- `GET /api/time-records/today` - Registros de hoje
- `POST /api/time-records` - Criar registro manual
- `POST /api/time-records/clock` - Registrar entrada/saída automática
- `DELETE /api/time-records/:id` - Excluir registro

### Health Check

- `GET /api/health` - Status da API

## Modelo de Dados

### Employee (Funcionário)
- `id`: ID único
- `name`: Nome completo
- `position`: Cargo
- `registration`: Matrícula (única)
- `workDays`: Dias da semana de trabalho (JSON array)

### TimeRecord (Registro de Ponto)
- `id`: ID único
- `employeeId`: ID do funcionário
- `date`: Data do registro
- `entryTime`: Horário de entrada (HH:MM)
- `exitTime`: Horário de saída (HH:MM)

### User (Usuário)
- `id`: ID único
- `username`: Nome de usuário
- `password`: Senha (hash)

## Ferramentas de Desenvolvimento

```bash
# Visualizar banco de dados
npm run prisma:studio

# Gerar cliente após mudanças no schema
npm run prisma:generate

# Aplicar mudanças no banco
npm run prisma:push
```

## Variáveis de Ambiente

| Variável | Descrição | Padrão |
|----------|-----------|---------|
| `DATABASE_URL` | String de conexão MySQL | - |
| `JWT_SECRET` | Chave secreta para JWT | - |
| `PORT` | Porta do servidor | 3001 |
| `NODE_ENV` | Ambiente de execução | development |
| `FRONTEND_URL` | URL do frontend para CORS | http://localhost:5173 |
