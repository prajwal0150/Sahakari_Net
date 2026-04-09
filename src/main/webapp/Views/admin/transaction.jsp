<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/admin/transaction-history.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Transaction History — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Transaction History</h1>
            <p class="text-gray-500 text-sm mt-0.5">All cooperative transactions (latest 200)</p>
        </div>
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Date</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Member</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Type</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Amount</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden md:table-cell">Balance After</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden lg:table-cell">Recorded By</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:choose>
                    <c:when test="${empty transactions}">
                        <tr><td colspan="6" class="px-5 py-10 text-center text-gray-400 text-sm">No transactions yet.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="t" items="${transactions}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-5 py-3.5 text-xs text-gray-500">${t.transactionDate}</td>
                                <td class="px-5 py-3.5 text-xs font-semibold text-gray-900">${t.memberName}</td>
                                <td class="px-5 py-3.5">
                                    <c:choose>
                                        <c:when test="${t.type == 'DEPOSIT'}">        <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2 py-0.5 rounded-full">Deposit</span></c:when>
                                        <c:when test="${t.type == 'WITHDRAWAL'}">     <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Withdrawal</span></c:when>
                                        <c:when test="${t.type == 'LOAN_DISBURSE'}">  <span class="inline-block bg-blue-100 text-blue-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan Disburse</span></c:when>
                                        <c:when test="${t.type == 'LOAN_REPAYMENT'}"> <span class="inline-block bg-amber-100 text-amber-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan Repayment</span></c:when>
                                        <c:otherwise>                                 <span class="inline-block bg-purple-100 text-purple-700 text-xs font-semibold px-2 py-0.5 rounded-full">Interest</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-5 py-3.5 text-xs font-bold text-gray-900">Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
                                <td class="px-5 py-3.5 text-xs text-gray-500 hidden md:table-cell">Rs. <fmt:formatNumber value="${t.balanceAfter}" pattern="#,##0.00"/></td>
                                <td class="px-5 py-3.5 text-xs text-gray-400 hidden lg:table-cell">${t.recordedByName}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
