<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Usuário</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/editar_usuario.css">
    <style>
        /* Mensagem de sucesso */
        .sucesso-message {
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
    </style>
</head>
<body>
    <header>
        <nav>
            <a href="index.html">Cadastro</a>
            <a href="listar.jsp">Listar</a>
        </nav>
    </header>

    <main>
        <%
            // Recupera o ID do usuário a ser editado
            String idUsuario = request.getParameter("id");
            String nome = "";
            String email = "";
            String senha = "";
            String numero = "";
            String mensagem = "";
            String tipoMensagem = "";

            // Preenche os campos com os dados do usuário
            if (idUsuario != null) {
                String dbURL = "jdbc:mysql://localhost:3306/login";
                String dbUser = "root";
                String dbPass = "";
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    // Estabelece a conexão com o banco de dados
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    // SQL para buscar os dados do usuário
                    String sql = "SELECT nome, email, senha, numero FROM gestao WHERE id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(idUsuario));
                    rs = stmt.executeQuery();

                    // Preenche os campos com os dados recuperados
                    if (rs.next()) {
                        nome = rs.getString("nome");
                        email = rs.getString("email");
                        senha = rs.getString("senha");
                        numero = rs.getString("numero");
                    } else {
                        mensagem = "Usuário não encontrado!";
                        tipoMensagem = "erro";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    mensagem = "Erro ao conectar ao banco de dados: " + e.getMessage();
                    tipoMensagem = "erro";
                } finally {
                    // Fecha a conexão com o banco de dados
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException se) {
                        se.printStackTrace();
                    }
                }
            }

            // Se o formulário for submetido, atualizar o usuário
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String nomeEditado = request.getParameter("nome");
                String emailEditado = request.getParameter("email");
                String senhaEditada = request.getParameter("senha");
                String numeroEditado = request.getParameter("numero");

                if (nomeEditado != null && emailEditado != null && numeroEditado != null) {
                    String dbURL = "jdbc:mysql://localhost:3306/login";
                    String dbUser = "root";
                    String dbPass = "";
                    Connection conn = null;
                    PreparedStatement stmt = null;

                    try {
                        // Estabelece a conexão com o banco de dados
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                        // SQL para atualizar os dados do usuário
                        String sql = "UPDATE gestao SET nome = ?, email = ?, senha = ?, numero = ? WHERE id = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, nomeEditado);
                        stmt.setString(2, emailEditado);
                        stmt.setString(3, senhaEditada);
                        stmt.setString(4, numeroEditado);
                        stmt.setInt(5, Integer.parseInt(idUsuario));

                        int result = stmt.executeUpdate();

                        if (result > 0) {
                            mensagem = "Usuário alterado com sucesso!";
                            tipoMensagem = "sucesso";
                            // Redireciona para a lista de usuários
                            response.sendRedirect("listar.jsp");
                        } else {
                            mensagem = "Falha ao alterar o usuário.";
                            tipoMensagem = "erro";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        mensagem = "Erro ao conectar ao banco de dados: " + e.getMessage();
                        tipoMensagem = "erro";
                    } finally {
                        // Fecha a conexão com o banco de dados
                        try {
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        } catch (SQLException se) {
                            se.printStackTrace();
                        }
                    }
                }
            }
        %>

        <!-- Formulário de Edição -->
        <form method="post" action="editar_usuario.jsp?id=<%= idUsuario %>">
            <label for="nome">Nome</label>
            <input type="text" id="nome" name="nome" value="<%= nome %>" required>

            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= email %>" required>

            <label for="senha">Senha</label>
            <input type="password" id="senha" name="senha" value="<%= senha %>" required>

            <label for="numero">Número</label>
            <input type="number" id="numero" name="numero" value="<%= numero %>" required>

            <button type="submit">Salvar</button>
        </form>

        <!-- Mensagem de feedback abaixo do formulário -->
        <div class="<%= tipoMensagem %>-message">
            <%= mensagem %>
        </div>

    </main>

    <footer></footer>
</body>
</html>
