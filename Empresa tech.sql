CREATE DATABASE empresa_tech1;

USE empresa_tech1;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  senha VARCHAR(255),
  perfil ENUM('admin', 'colaborador') DEFAULT 'colaborador',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  empresa VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  telefone VARCHAR(15),
  endereco TEXT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projetos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  descricao TEXT,
  cliente_id INT,
  gerente_projeto_id INT,
  data_inicio DATE,
  data_fim DATE,
  status ENUM('planejado', 'em andamento', 'concluido', 'suspenso') DEFAULT 'planejado',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (gerente_projeto_id) REFERENCES funcionarios(id)
);

CREATE TABLE funcionarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  cargo VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  telefone VARCHAR(15),
  data_contratacao DATE,
  salario DECIMAL(10,2),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tarefas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  projeto_id INT,
  descricao TEXT,
  responsavel_id INT,
  data_inicio DATE,
  data_fim DATE,
  status ENUM('não iniciado', 'em progresso', 'concluído', 'atrasado') DEFAULT 'não iniciado',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (projeto_id) REFERENCES projetos(id),
  FOREIGN KEY (responsavel_id) REFERENCES funcionarios(id)
);

CREATE TABLE faturas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT,
  projeto_id INT,
  data_emissao DATE,
  valor_total DECIMAL(10,2),
  status ENUM('pendente', 'pago', 'cancelado') DEFAULT 'pendente',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id),
  FOREIGN KEY (projeto_id) REFERENCES projetos(id)
);

CREATE TABLE pagamentos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fatura_id INT,
  data_pagamento DATE,
  valor_pagamento DECIMAL(10,2),
  metodo_pagamento ENUM('transferência', 'boleto', 'cartão') DEFAULT 'transferência',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (fatura_id) REFERENCES faturas(id)
);

CREATE TABLE suporte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT,
  assunto VARCHAR(255),
  descricao TEXT,
  status ENUM('aberto', 'em andamento', 'resolvido', 'fechado') DEFAULT 'aberto',
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  descricao TEXT,
  preco DECIMAL(10,2),
  estoque INT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE servicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100),
  descricao TEXT,
  preco DECIMAL(10,2),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT clientes.nome, SUM(pagamentos.valor_pagamento) AS total_pago
FROM clientes
JOIN faturas ON clientes.id = faturas.cliente_id
JOIN pagamentos ON faturas.id = pagamentos.fatura_id
WHERE faturas.status = 'pago'
GROUP BY clientes.nome;

SELECT projetos.nome AS projeto, funcionarios.nome AS funcionario
FROM projetos
JOIN tarefas ON projetos.id = tarefas.projeto_id
JOIN funcionarios ON tarefas.responsavel_id = funcionarios.id;
