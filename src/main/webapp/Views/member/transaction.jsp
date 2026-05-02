<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/member/transactions.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My Transactions — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-5xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">My Transactions</h1>
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Date</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Type</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase hidden md:table-cell">Description</th>
                    <th class="text-right px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase">Amount</th>
                    <th class="text-right px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase hidden lg:table-cell">Balance After</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:forEach var="t" items="${transactions}">
                    <tr class="hover:bg-gray-50">
                        <td class="px-5 py-3.5 text-xs text-gray-500">${t.transactionDate}</td>
                        <td class="px-5 py-3.5">
                            <c:choose>
                                <c:when test="${t.type == 'DEPOSIT'}">        <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2 py-0.5 rounded-full">Deposit</span></c:when>
                                <c:when test="${t.type == 'WITHDRAWAL'}">     <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Withdrawal</span></c:when>
                                <c:when test="${t.type == 'LOAN_DISBURSE'}">  <span class="inline-block bg-blue-100 text-blue-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan Received</span></c:when>
                                <c:when test="${t.type == 'LOAN_REPAYMENT'}"> <span class="inline-block bg-amber-100 text-amber-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan Repayment</span></c:when>
                                <c:otherwise>                                 <span class="inline-block bg-purple-100 text-purple-700 text-xs font-semibold px-2 py-0.5 rounded-full">Interest</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-5 py-3.5 text-xs text-gray-500 hidden md:table-cell">${t.description}</td>
                        <td class="px-5 py-3.5 text-xs font-bold text-gray-900 text-right">Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
                        <td class="px-5 py-3.5 text-xs text-gray-400 text-right hidden lg:table-cell">Rs. <fmt:formatNumber value="${t.balanceAfter}" pattern="#,##0.00"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty transactions}"><tr><td colspan="5" class="px-5 py-10 text-center text-gray-400 text-sm">No transactions found.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
