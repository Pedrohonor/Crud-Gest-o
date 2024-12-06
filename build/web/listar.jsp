<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.sql.*" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Usuários</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/lista.css">
</head>
<body>
    <header>
        <nav>
            <a href="index.html">Cadastro</a>
            <a href="listar.jsp">Listar</a>
        </nav>
    </header>
    <main>
        <table>
            <tr>
                <th>ID</th> <!-- Coluna ID adicionada -->
                <th>Nome</th>
                <th>Email</th>
                <th>Senha</th>
                <th>Número</th>
                <th>Ações</th>
            </tr>

            <%
                // Definir variáveis de conexão com o banco de dados
                String dbURL = "jdbc:mysql://localhost:3306/login"; 
                String dbUser = "root"; // usuário do banco de dados
                String dbPass = ""; // senha do banco de dados

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    // Estabelecer a conexão com o banco de dados
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                    // SQL para obter todos os usuários (agora incluindo o campo id)
                    String sql = "SELECT id, nome, email, senha, numero FROM gestao";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();

                    // Laço para exibir todos os usuários cadastrados
                    while (rs.next()) {
                        int id = rs.getInt("id");  // Recuperar o id
                        String nome = rs.getString("nome");
                        String email = rs.getString("email");
                        String senha = rs.getString("senha"); // Senha será mascarada
                        String numero = rs.getString("numero");
            %>
            
            <tr>
                <td><%= id %></td> <!-- Exibir o ID -->
                <td><%= nome %></td>
                <td><%= email %></td>
                <td>********</td> <!-- Senha mascarada -->
                <td><%= numero %></td>
                <td>
                    <!-- Botão de editar (não implementado na JSP) -->
                    <a href="editar_usuario.jsp?id=<%= id %>" class="editar-btn">Editar</a>
                    <!-- Botão de excluir -->
                    <form action="excluir_usuario.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit" class="excluir-btn">Excluir</button>
                    </form>
                </td>
            </tr>

            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // Fechar a conexão com o banco
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException se) {
                        se.printStackTrace();
                    }
                }
            %>

        </table>
    </main>
    <footer></footer>

    <!-- Script para confirmação de exclusão -->
    <script>
        document.querySelectorAll('.excluir-btn').forEach(button => {
            button.addEventListener('click', function() {
                if (!confirm("Tem certeza que deseja excluir este usuário?")) {
                    event.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
