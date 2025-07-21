/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import dao.PedidoDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/actualizar-proceso")
public class ActualizarProcesoPedidoServlet extends HttpServlet {
    private final PedidoDao pedidoDao = new PedidoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idPedido = Integer.parseInt(request.getParameter("idPedido"));
        String nuevoProceso = request.getParameter("nuevoProceso");

        pedidoDao.actualizarEstadoPedido(idPedido, nuevoProceso);
        response.sendRedirect(request.getContextPath() + "/pedidos");
    }
}

   
