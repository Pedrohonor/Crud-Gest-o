<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Pega o ID do usuário a partir da requisição
    String idStr = request.getParameter("id");
    
    if (idStr != null) {
        int id = Integer.parseInt(idStr); // Converte o ID para um inteiro

        String dbURL = "jdbc:mysql://localhost:3306/login";
        String dbUser = "root";
        String dbPass = "";
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Estabelece a conexão com o banco de dados
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // SQL para excluir o usuário com base no ID
            String sql = "DELETE FROM gestao WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, id);  // Passa o ID para a query

            // Executa a exclusão
            int result = stmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("listar.jsp"); // Redireciona para a lista após excluir
            } else {
                out.println("Erro ao excluir usuário");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException se) {
                se.printStackTrace();
            }
        }
    } else {
        out.println("ID inválido");
    }
%>
