package com.sahakarinet.sahakari.SahakariNet.Controller;

import com.sahakarinet.sahakari.SahakariNet.model.dao.ReportDao;
import com.sahakarinet.sahakari.SahakariNet.model.dao.SavingAcountDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {

	private final ReportDao reportDao = new ReportDao();
	private final SavingAcountDao savingAccountDao = new SavingAcountDao();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			loadReportData(request);
			request.getRequestDispatcher("/Views/admin/reports.jsp").forward(request, response);
		} catch (Exception exception) {
			exception.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/report?error=reportLoadFailed");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (!"credit-savings-interest".equals(action)) {
			response.sendRedirect(request.getContextPath() + "/report");
			return;
		}

		HttpSession session = request.getSession(false);
		Object userIdObj = session != null ? session.getAttribute("userId") : null;
		if (!(userIdObj instanceof Number)) {
			response.sendRedirect(request.getContextPath() + "/report?error=invalidRequest");
			return;
		}

		try {
			int adminId = ((Number) userIdObj).intValue();
			int creditedCount = savingAccountDao.creditMonthlyInterestForAll(adminId);

			if (creditedCount >= 0) {
				response.sendRedirect(request.getContextPath() + "/report?msg=interestCredited&count=" + creditedCount);
			} else {
				response.sendRedirect(request.getContextPath() + "/report?error=interestCreditFailed");
			}
		} catch (Exception exception) {
			exception.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/report?error=interestCreditFailed");
		}
	}

	private void loadReportData(HttpServletRequest request) {
		String period = request.getParameter("period");
		if (period == null || period.isBlank()) {
			period = "all";
		}

		request.setAttribute("monthlySavings", reportDao.monthlySavings());
		request.setAttribute("loanRecovery", reportDao.loanRecovery(period));
		request.setAttribute("selectedPeriod", period);
		request.setAttribute("interestEarned", reportDao.totalInterestEarned());
	}
}
