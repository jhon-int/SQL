CREATE DATABASE clinica_si

CREATE TABLE especialidade
(
 id_especialidades INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE medico
(
 id_medicos INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 sexo ENUM("F","M"),
 
 id_especialidades INT NOT NULL,
 FOREIGN KEY(id_especialidades) REFERENCES especialidade (id_especialidades)
)

CREATE TABLE paciente
(
 id_pacientes INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 telefone CHAR(11),
 datan DATE NOT NULL
)

CREATE TABLE exame
(
 id_exames INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE paciente_exame
(
 id_pacientes_exames INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 id_exames INT NOT NULL,
 id_pacientes INT NOT NULL,
 data_exame DATE NOT NULL,
 hora_exame TIME NOT NULL,
 
 FOREIGN KEY(id_exames) REFERENCES exame (id_exames)
)

CREATE TABLE medico_paciente
(
 id_medicos_pacientes INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 id_medicos INT NOT NULL,
 id_pacientes INT NOT NULL,
 data_atendimento DATE NOT NULL,
 hora_atendimento TIME NOT NULL,
 
 FOREIGN KEY(id_medicos) REFERENCES medico (id_medicos),
 FOREIGN KEY(id_pacientes) REFERENCES paciente (id_pacientes)
)

INSERT INTO especialidade
(descritivo) VALUES ('Sei la2')

INSERT INTO exame
(descritivo) VALUES ('Sei la exame'), ('Sei la exame2') 

INSERT INTO medico
(nome, sexo, id_especialidades) VALUES ('Lucas','M',2)

INSERT INTO paciente
(nome, telefone, datan) VALUES ('Bia', '89456123456', '17/05/14'), ('Paula', '89456123456', '17/05/05')

INSERT INTO medico_paciente
(id_medicos, id_pacientes, data_atendimento, hora_atendimento) VALUES (4,1,'17/05/01','14:02:15'), (6,2,'17/05/01','15:08:15')

INSERT INTO paciente_exame
(id_exames, id_pacientes, data_exame, hora_exame) VALUES (1,1,'17/02/03','03:02:02'), (2,2,'17/02/04','09:30:02')