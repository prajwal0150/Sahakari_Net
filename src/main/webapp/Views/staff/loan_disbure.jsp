<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/staff/loan-disburse.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Disburse Loan — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-3xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Disburse Loan</h1>
        <p class="text-gray-500 text-sm mb-6">Release approved loan funds to member</p>

        <c:if test="${param.msg == 'disbursed'}">
            <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-5 text-sm">✅ Loan disbursed and repayment schedule created.</div>
        </c:if>

        <!-- List of approved loans -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100"><h2 class="text-sm font-bold text-gray-700">Approved Loans — Ready to Disburse</h2></div>
            <c:choose>
                <c:when test="${empty approvedLoans}">
                    <div class="px-5 py-10 text-center text-gray-400 text-sm">No approved loans waiting for disbursement.</div>
                </c:when>
                <c:otherwise>
                    <div class="divide-y divide-gray-50">
                        <c:forEach var="l" items="${approvedLoans}">
                            <div class="p-5 flex items-center justify-between gap-4">
                                <div>
                                    <div class="font-bold text-gray-900 text-sm">${l.memberName} <span class="text-gray-400 font-normal">&bull; Loan #${l.id}</span></div>
                                    <div class="text-xs text-gray-500 mt-0.5">Rs. <fmt:formatNumber value="${l.amount}" pattern="#,##0"/> &bull; ${l.durationMonths} months &bull; EMI: Rs. <fmt:formatNumber value="${l.monthlyEmi}" pattern="#,##0.00"/></div>
                                    <div class="text-xs text-gray-400 mt-0.5">${l.purpose}</div>
                                </div>
                                <form action="${pageContext.request.contextPath}/loan" method="post">
                                    <input type="hidden" name="action" value="disburse">
                                    <input type="hidden" name="loanId" value="${l.id}">
                                    <button type="submit" onclick="return confirm('Disburse Rs. ${l.amount} to ${l.memberName}?')"
                                            class="bg-green-700 text-white text-xs font-bold px-4 py-2 rounded-xl hover:bg-green-800 transition whitespace-nowrap">
                                        Disburse →
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div></div>
</body></html>
