<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/member/repayment-schedule.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Repayment Schedule — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">

        <a href="${pageContext.request.contextPath}/member?page=my-loans" class="inline-flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
            Back to My Loans
        </a>

        <h1 class="text-2xl font-bold text-gray-900 mb-1">Repayment Schedule</h1>
        <c:if test="${loan != null}">
            <p class="text-gray-500 text-sm mb-6">Loan #${loan.id} &bull; Rs. <fmt:formatNumber value="${loan.amount}" pattern="#,##0"/> &bull; ${loan.durationMonths} months &bull; EMI: Rs. <fmt:formatNumber value="${loan.monthlyEmi}" pattern="#,##0.00"/></p>
        </c:if>

        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">No.</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Due Date</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Amount Due</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Paid</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Status</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:forEach var="r" items="${schedule}">
                    <tr class="${r.defaulted ? 'bg-red-50' : 'hover:bg-gray-50'} transition">
                        <td class="px-5 py-3.5 text-xs text-gray-500 font-mono">${r.instalmentNo}</td>
                        <td class="px-5 py-3.5 text-xs ${r.defaulted ? 'text-red-600 font-semibold' : 'text-gray-700'}">${r.dueDate}</td>
                        <td class="px-5 py-3.5 text-xs font-bold text-gray-900">Rs. <fmt:formatNumber value="${r.dueAmount}" pattern="#,##0.00"/></td>
                        <td class="px-5 py-3.5 text-xs ${r.paidAmount > 0 ? 'text-green-700 font-bold' : 'text-gray-400'}">
                            <c:choose>
                                <c:when test="${r.paidAmount > 0}">Rs. <fmt:formatNumber value="${r.paidAmount}" pattern="#,##0.00"/></c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-5 py-3.5">
                            <c:choose>
                                <c:when test="${r.paidAmount >= r.dueAmount}"><span class="inline-block bg-green-100 text-green-700 text-xs font-bold px-2.5 py-1 rounded-full">✓ Paid</span></c:when>
                                <c:when test="${r.defaulted}">               <span class="inline-block bg-red-100 text-red-600 text-xs font-bold px-2.5 py-1 rounded-full">Overdue</span></c:when>
                                <c:otherwise>                               <span class="inline-block bg-gray-100 text-gray-500 text-xs font-bold px-2.5 py-1 rounded-full">Pending</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty schedule}"><tr><td colspan="5" class="px-5 py-10 text-center text-gray-400 text-sm">No schedule found.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
