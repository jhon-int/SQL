/* 1- */
CREATE OR REPLACE VIEW VW_ALUNOS AS
SELECT 
	aluno.id_aluno "Codigo", 
	aluno.nome, 
	curso.descritivo, 
	YEAR(CURRENT_DATE) - YEAR(aluno.datan) "Idade", 
	COUNT(aluno_disciplina.id_aluno) "NroDiscip",
	CONCAT("R$ ",FORMAT(SUM(disciplina.valor),2)) "ValorMens",
	CASE
		WHEN YEAR(CURRENT_DATE) - YEAR(aluno.datan) BETWEEN 18 AND 25 THEN CONCAT("R$ ",FORMAT(SUM(disciplina.valor*0.05),2))
		WHEN YEAR(CURRENT_DATE) - YEAR(aluno.datan) > 25 THEN CONCAT("R$ ",FORMAT(SUM(disciplina.valor*0.1),2))
		ELSE 0
	END "ValorDesconto"
FROM aluno
INNER JOIN curso ON(curso.id_curso = aluno.id_curso)
INNER JOIN aluno_disciplina ON(aluno_disciplina.id_aluno = aluno.id_aluno)
INNER JOIN disciplina ON(disciplina.id_disciplina = aluno_disciplina.id_disciplina)
GROUP BY aluno_disciplina.id_aluno
HAVING COUNT(aluno_disciplina.id_aluno) >= 3
ORDER BY aluno.nome

/* 2- */
SELECT 
	curso.id_curso "Codigo", 
	curso.descritivo,
	(SELECT COUNT(aluno.id_aluno) FROM aluno WHERE aluno.sexo = "M" AND curso.id_curso = aluno.id_curso) "Nro de Homens",
	(SELECT COUNT(aluno.id_aluno) FROM aluno WHERE aluno.sexo = "F" AND curso.id_curso = aluno.id_curso) "Nro de Mulheres",
	(SELECT COUNT(aluno.id_aluno) FROM aluno WHERE curso.id_curso = aluno.id_curso) "Total Geral"
FROM curso
INNER JOIN aluno ON(curso.id_curso = aluno.id_curso)
GROUP BY curso.id_curso

/* 3- */
SELECT 
	aluno.id_aluno "Codigo", 
	aluno.nome, 
	curso.descritivo,
	FORMAT((SELECT AVG(aluno_disciplina.Media) FROM aluno_disciplina WHERE aluno_disciplina.id_aluno = aluno.id_aluno),2) "Media do Aluno",
	FORMAT((SELECT AVG(aluno_disciplina.Media) FROM aluno_disciplina),2) "Media da Faculdade"
FROM aluno
INNER JOIN curso ON(curso.id_curso = aluno.id_curso)
INNER JOIN aluno_disciplina ON(aluno_disciplina.id_aluno = aluno.id_aluno)
INNER JOIN disciplina ON(disciplina.id_disciplina = aluno_disciplina.id_disciplina)
WHERE (SELECT AVG(aluno_disciplina.Media) FROM aluno_disciplina WHERE aluno_disciplina.id_aluno = aluno.id_aluno) > (SELECT AVG(aluno_disciplina.Media) FROM aluno_disciplina)
GROUP BY aluno.id_aluno

/* 4- */
SELECT 
	aluno.id_aluno "Codigo", 
	aluno.nome, 
	curso.descritivo,
	"",
	""
FROM aluno
INNER JOIN curso ON(curso.id_curso = aluno.id_curso)
INNER JOIN aluno_disciplina ON(aluno_disciplina.id_aluno = aluno.id_aluno)
INNER JOIN disciplina ON(disciplina.id_disciplina = aluno_disciplina.id_disciplina)
WHERE aluno.id_aluno = 2
GROUP BY aluno.id_aluno

UNION ALL

SELECT 
	"", 
	"", 
	"",
	disciplina.descricao "Disciplina",
	disciplina.valor "Valor"
FROM aluno
INNER JOIN curso ON(curso.id_curso = aluno.id_curso)
INNER JOIN aluno_disciplina ON(aluno_disciplina.id_aluno = aluno.id_aluno)
INNER JOIN disciplina ON(disciplina.id_disciplina = aluno_disciplina.id_disciplina)
WHERE aluno.id_aluno = 2

UNION ALL
SELECT "", "", "", "Total", SUM(disciplina.valor)
FROM disciplina
INNER JOIN aluno_disciplina ON(disciplina.id_disciplina = aluno_disciplina.id_disciplina)
WHERE aluno_disciplina.id_aluno = 2

/* 5- */
UPDATE disciplina 
SET disciplina.valor = disciplina.valor*1.10
WHERE disciplina.cargah = 4 
 AND disciplina.id_disciplina IN (SELECT aluno_disciplina.id_disciplina FROM aluno_disciplina GROUP BY aluno_disciplina.id_disciplina HAVING COUNT(aluno_disciplina.id_disciplina) > 3)
 
