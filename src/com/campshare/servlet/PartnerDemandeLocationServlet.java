package com.campshare.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.campshare.model.Reservation;
import com.campshare.model.User;
import com.campshare.service.PartnerService;
import com.campshare.service.ReservationService;

@WebServlet("/partner/DemandeLocation")
public class PartnerDemandeLocationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PartnerService partnerService = new PartnerService();
        ReservationService reservationService = new ReservationService();

        // Get parameters from request
        String partnerEmail = request.getParameter("email");
        String status = request.getParameter("status");
        String dateFilter = request.getParameter("date");
        String sort = request.getParameter("sort");
        String search = request.getParameter("search");

        // Default values
        if (status == null || status.equals("all")) status = "";
        if (dateFilter == null) dateFilter = "all";
        if (sort == null) sort = "date-desc";
        if (search == null) search = "";
        final String finalDateFilter = dateFilter;

        // For testing, hard-coded email (replace with partnerEmail if needed)
        
        User user1 = (User) request.getSession().getAttribute("authenticatedUser");
        if (user1 == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String email = user1.getEmail();
        User user = partnerService.getPartnerByEmail(email);


        request.setAttribute("user", user);
        long partnerId = user.getId();

        // Get reservations with total amount
        List<Reservation> reservationsWithMontantTotal = reservationService.getReservationsWithMontantTotal(email);

        // ---- Filter by status ----
                // ---- Filter by status ----
        final String finalStatus = status;

        if (!finalStatus.isEmpty()) {
            reservationsWithMontantTotal = reservationsWithMontantTotal.stream()
                .filter(r -> r.getStatus().equalsIgnoreCase(finalStatus))
                .collect(Collectors.toList());
        }
      

        // ---- Filter by search (client name or equipment title) ----
        if (!search.isEmpty()) {
            String searchLower = search.toLowerCase();
            reservationsWithMontantTotal = reservationsWithMontantTotal.stream()
                    .filter(r -> r.getClient().getUsername().toLowerCase().contains(searchLower)
                            || r.getListing().getItem().getTitle().toLowerCase().contains(searchLower))
                    .collect(Collectors.toList());
        }

        // ---- Filter by date ----
        LocalDate now = LocalDate.now();
        reservationsWithMontantTotal = reservationsWithMontantTotal.stream()
            .filter(r -> {
                // Convert java.sql.Date to LocalDate
                LocalDate startDate;

                if (r.getStartDate() instanceof java.sql.Date) {
                    startDate = ((java.sql.Date) r.getStartDate()).toLocalDate();
                } else {
                    startDate = r.getStartDate().toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDate();
                }
                

                switch (finalDateFilter) {
                    case "this-month":
                        return startDate.getMonth() == now.getMonth() && startDate.getYear() == now.getYear();
                    case "last-month":
                        LocalDate lastMonthStart = now.minusMonths(1).withDayOfMonth(1);
                        LocalDate lastMonthEnd = lastMonthStart.withDayOfMonth(lastMonthStart.lengthOfMonth());
                        return !startDate.isBefore(lastMonthStart) && !startDate.isAfter(lastMonthEnd);
                    case "last-3-months":
                        LocalDate threeMonthsAgo = now.minusMonths(3);
                        return !startDate.isBefore(threeMonthsAgo);
                    default:
                        return true;
                }
            })
            .collect(Collectors.toList());

        // ---- Sort ----
        if (sort.equals("date-asc")) {
            reservationsWithMontantTotal.sort(Comparator.comparing(Reservation::getStartDate));
        } else { // date-desc default
            reservationsWithMontantTotal.sort(Comparator.comparing(Reservation::getStartDate).reversed());
        }

        // Set attribute for JSP
        request.setAttribute("ReservationsWithMontantTotal", reservationsWithMontantTotal);

        // Forward to JSP
        request.getRequestDispatcher("/jsp/partner/DemandeLocation.jsp").forward(request, response);
    }
}
