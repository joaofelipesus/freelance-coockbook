
# Solid Queue

Em alguns projetos, é necessário executar ações em segundo plano, como geração de relatórios, envio de emails ou outras tarefas pesadas. Para gerenciar essas tarefas, podemos utilizar as gems solid_queue e mission_control_jobs.

A solid_queue é responsável pela execução das tarefas em segundo plano, enquanto a mission_control_jobs fornece uma interface para acompanhar o status das execuções (sucesso ou erro).

A escolha da solid_queue se justifica pela simplicidade da nossa infraestrutura, dispensando a necessidade do Redis, ao contrário de outras soluções como o Sidekiq.

### Documentação

Este documento detalha a instalação e configuração das gems solid_queue e mission_control_jobs no ambiente Heroku, utilizado pelo time até o momento.

Links para Documentação Oficial:

    Solid Queue: https://github.com/rails/solid_queue
    Mission Control Jobs: https://github.com/topics/mission-control

Instalação da Solid Queue

1. Adicionar Gem ao Gemfile

Adicione a gem solid_queue ao Gemfile do seu projeto:
Ruby

```ruby
gem "solid_queue"
```

2. Instalar Gem

Instale a gem utilizando o comando:
Ruby

```bash
bundle install
```
3. Gerar Migrations

Gere as migrations necessárias para o solid_queue no projeto:
Ruby

```bash
bundle exec rails generate solid_queue:install
```
4. Executar Migrations

Execute as migrations geradas:
```bash
bundle exec rails db:migrate
```

Configuração no Docker Compose

1. Adicionar Container no `docker-compose.yml`

Adicione um novo container no `docker-compose.yml` para executar os jobs agendados:

```yaml
solid_queue:
  depends_on:
    - postgres
  build: .
  stdin_open: true
  tty: true
  command: bash -c "rm -f /usr/src/app/tmp/pids/server.pid && (bundle check || bundle install) && bundle exec rails solid_queue:start"
  volumes:
    - .:/usr/src/app
    - gems:/gems
  env_file:
    - .env/secrets

```

### Ambiente de produção

Caso não seja necessário uma nova máquina para executar o solid queue, é possível executa-lo junto do puma. Para isso, adicione ao arquivo `config/puma.rb`:
```ruby
plugin :solid_queue if Rails.env.production?
```

Caso uma máquina separada seja necessária para o projeto, adicione a seguinte linha ao `Procfile` do projeto:
```
solid_queue: bundle exec rails solid_queue:start
```

Pronto!

Com essas etapas, você já estará pronto para utilizar a gem solid_queue.

Observações

- Certifique-se de ter o PostgreSQL instalado e configurado em seu ambiente.
- Adapte os comandos e configurações de acordo com as especificidades do seu projeto.


# MissionControlJobs
MissionControlJobs é uma gem que oferece uma interface web e API Active Job para gerenciar jobs em segundo plano. Através da gem, é possível visualizar e inspecionar filas, jobs e workers, além de refazer ou descartar jobs com falha, sendo indispensável para solucionar problemas e monitorar jobs em segundo plano.

Observação: No momento, essa gem não é compatível com aplicações API only.

### Instalação

1. Adicionar a gem ao Gemfile
```
gem "mission_control-jobs"
```

2. Instalar a gem
```ruby
bundle install
```

3. Montar a engine no routes.rb

Para acessar a interface da gem, adicione a engine no arquivo `routes.rb`:
```ruby
Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"
  ...
end
```

Pronto! A interface da gem estará disponível em /jobs.

### Configuração

Por padrão, as rotas da gem usam o ApplicationController. Se nenhuma autenticação for necessária, qualquer usuário poderá acessar a interface.

Para restringir o acesso e exigir login e senha:

1. Criar um controller para autenticação

Crie um novo controller para gerenciar a autenticação de usuários com acesso à interface:

```bash
bundle exec rails g controller staff_controller
```

2. Especificar o controller no application.rb

No arquivo application.rb, configure o novo controller para ser usado nas rotas do Mission Control Jobs:

```ruby
config.mission_control.jobs.base_controller_class = "StaffController"
```

3. Implementar a autenticação no controller

Adicione o seguinte código ao controller criado (StaffController):
```ruby

class StaffController < ActionController::Base
  http_basic_authenticate_with name: ENV.fetch('JOBS_MONITOR_PANEL_USER', ''),
                               password: ENV.fetch('JOBS_MONITOR_PANEL_PASSWORD', ''),
                               if: :in_production?

  private

  def in_production?
    Rails.env.production?
  end
end
```


4. Adicionar as variáveis de ambiente

Em ambiente de produção, adicione as variáveis de ambiente JOBS_MONITOR_PANEL_USER e JOBS_MONITOR_PANEL_PASSWORD com as credenciais de acesso desejadas.

Pronto! Ao tentar acessar a rota /jobs, o login e senha serão solicitados.

Observações:

- A autenticação básica é utilizada por padrão. Você pode implementar outras estratégias de autenticação de acordo com suas necessidades.
- As variáveis de ambiente JOBS_MONITOR_PANEL_USER e JOBS_MONITOR_PANEL_PASSWORD devem ser configuradas apenas em ambiente de produção.
