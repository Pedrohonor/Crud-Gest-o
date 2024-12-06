<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.sql.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastro</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/cadastro.css">
    <style>
        /* Mensagem de sucesso */
        .success-message {
            background-color: #28a745; /* Verde de sucesso */
            color: white;
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
            border: 2px solid #218838;
            max-width: 400px;
            margin: 20px auto;
            font-size: 16px;
        }

        /* Mensagem de erro */
        .error-message {
            background-color: #dc3545; /* Vermelho de erro */
            color: white;
            padding: 15px;
            margin-top: 20px;
            border-radius: 5px;
            font-weight: bold;
            text-align: center;
            border: 2px solid #c82333;
            max-width: 400px;
            margin: 20px auto;
            font-size: 16px;
        }

        /* Estilização dos botões */
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            text-align: center;
            text-decoration: none;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }

        /* Estilo do botão de "Voltar para o Cadastro" */
        .button-back {
            background-color: #dc3545; /* Vermelho */
        }

        /* Estilo do botão de "Próxima Página" */
        .button-next {
            background-color: #28a745; /* Verde */
        }

        /* Estilo para os campos com erro */
        .error-field {
            border: 2px solid #c82333; /* Borda vermelha para campos com erro */
        }
    </style>
</head>
<body>

<%
    // Recuperar os dados do formulário
    String nome = request.getParameter("nome");
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    String numero = request.getParameter("numero");

    // Variáveis para mensagens de erro
    String erro = "";
    boolean erroValidacao = false;
    String erroNome = "";
    String erroNumero = "";
    String erroEmail = ""; // Variável para armazenar a mensagem de erro do email

    // Validação do campo nome (aceitar letras A-Z e espaços, sem acentos e sem "ç")
    if (nome == null || !nome.matches("^[A-Za-z ]+$")) {
        erroNome = "O nome deve conter apenas letras de A a Z, sem acentos, caracteres especiais ou 'ç', e pode incluir espaços.";
        erroValidacao = true;
    }

    // Validação do campo número (somente 11 caracteres)
    if (numero == null || numero.length() != 11) {
        erroNumero = "O número deve ter exatamente 11 dígitos.";
        erroValidacao = true;
    }

    // Verificar se o email já existe no banco de dados
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    boolean emailJaExiste = false;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/login";
        String dbUser = "root";
        String dbPass = "";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Verifica se o email já existe
        String sqlCheckEmail = "SELECT * FROM gestao WHERE email = ?";
        stmt = conn.prepareStatement(sqlCheckEmail);
        stmt.setString(1, email);
        rs = stmt.executeQuery();

        if (rs.next()) {
            emailJaExiste = true;
            erroEmail = "O email informado já está em uso. Tente outro.";
            erroValidacao = true;
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }

    // Se houver erro de validação, exibe a mensagem e não processa o cadastro
    if (erroValidacao) {
        out.println("<div class='error-message'>" + erroNome + "<br>" + erroNumero + "<br>" + erroEmail + "</div>");
    }
%>

<main>
    <form action="cadastrar.jsp" method="post">
        <label for="nome">Nome</label>
        <!-- Manter o valor do campo 'nome' caso tenha erro -->
        <input type="text" id="nome" name="nome" value="<%= nome != null ? nome : "" %>" 
               pattern="^[A-Za-z ]+$" required title="O nome deve conter apenas letras de A a Z, sem acentos, caracteres especiais ou 'ç', e pode incluir espaços."
               class="<%= erroNome.isEmpty() ? "" : "error-field" %>">

        <label for="email">Email</label>
        <!-- Manter o valor do campo 'email' -->
        <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" required 
               class="<%= erroEmail.isEmpty() ? "" : "error-field" %>">

        <label for="senha">Senha</label>
        <!-- Manter o valor do campo 'senha' -->
        <input type="password" id="senha" name="senha" value="<%= senha != null ? senha : "" %>" required>

        <label for="numero">Número</label>
        <!-- Manter o valor do campo 'numero' e adicionar validação -->
        <input type="number" id="numero" name="numero" value="<%= numero != null ? numero : "" %>" 
               pattern="^\d{11}$" placeholder="11 99999-9999" required title="O número deve ter exatamente 11 dígitos."
               class="<%= erroNumero.isEmpty() ? "" : "error-field" %>">

        <button type="submit">Cadastrar</button>
    </form>

    <%
        // Se a validação falhou, mostra o botão "Voltar para o Cadastro"
        if (erroValidacao) {
            out.println("<a href='cadastrar.html' class='button button-back'>Voltar para o cadastro</a>");
        } else {
            // Processa o cadastro no banco de dados se não houver erro
            conn = null;
            stmt = null;
            try {
                String dbURL = "jdbc:mysql://localhost:3306/login";
                String dbUser = "root"; 
                String dbPass = ""; 

                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                // SQL de inserção
                String sql = "INSERT INTO gestao (nome, email, senha, numero) VALUES (?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, nome);
                stmt.setString(2, email);
                stmt.setString(3, senha);
                stmt.setString(4, numero);

                int result = stmt.executeUpdate();

                if (result > 0) {
                    out.println("<div class='success-message'>Cadastro realizado com sucesso!</div>");
                    out.println("<a href='listar.jsp' class='button button-next'>Próxima Página</a>");
                } else {
                    out.println("<div class='error-message'>Falha ao realizar cadastro, tente novamente.</div>");
                    out.println("<a href='cadastrar.html' class='button button-back'>Voltar para o cadastro</a>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='error-message'>Erro ao conectar ao banco de dados: " + e.getMessage() + "</div>");
                out.println("<a href='cadastrar.html' class='button button-back'>Voltar para o cadastro</a>");
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException se) {
                    se.printStackTrace();
                }
            }
        }
    %>
</main>

</body>
</html>
