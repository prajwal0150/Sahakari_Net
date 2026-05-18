<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/member/savings.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My Savings — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">My Savings</h1>

        <c:if test="${savings != null}">
            <div class="grid grid-cols-3 gap-4 mb-6">
                <div class="bg-gradient-to-br from-green-700 to-green-900 rounded-2xl p-6 text-white col-span-2">
                    <div class="text-xs text-green-200 mb-2">Current Balance</div>
                    <div class="text-4xl font-extrabold">Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></div>
                    <div class="text-xs text-green-300 mt-2">Interest rate: ${savings.interestRate}% per year</div>
                </div>
                <div class="bg-white rounded-2xl border border-gray-100 p-6">
                    <div class="text-xs text-gray-400 mb-2">Share Capital (Rs.)</div>
                    <div class="text-2xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${savings.shareCapital}" pattern="#,##0.00"/></div>
                    <div class="text-xs text-gray-400 mt-1">Fixed membership share</div>
                </div>
            </div>
        </c:if>

        <!-- Transaction history -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100"><h2 class="text-sm font-bold text-gray-700">Savings Transactions</h2></div>
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Date</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Type</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Description</th>
                    <th class="text-right px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Amount</th>
                    <th class="text-right px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Balance</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:forEach var="t" items="${txHistory}">
                    <c:if test="${t.type == 'DEPOSIT' || t.type == 'WITHDRAWAL' || t.type == 'INTEREST_CREDIT'}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-5 py-3 text-xs text-gray-500">${t.transactionDate}</td>
                            <td class="px-5 py-3">
                                <c:choose>
                                    <c:when test="${t.type == 'DEPOSIT'}">         <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2 py-0.5 rounded-full">Deposit</span></c:when>
                                    <c:when test="${t.type == 'WITHDRAWAL'}">      <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Withdrawal</span></c:when>
                                    <c:otherwise>                                  <span class="inline-block bg-purple-100 text-purple-700 text-xs font-semibold px-2 py-0.5 rounded-full">Interest</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-5 py-3 text-xs text-gray-500">${t.description}</td>
                            <td class="px-5 py-3 text-xs font-bold text-gray-900 text-right">
                                <c:choose>
                                    <c:when test="${t.type == 'WITHDRAWAL'}"><span class="text-red-600">-</span></c:when>
                                    <c:otherwise><span class="text-green-600">+</span></c:otherwise>
                                </c:choose>
                                Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/>
                            </td>
                            <td class="px-5 py-3 text-xs text-gray-500 text-right">Rs. <fmt:formatNumber value="${t.balanceAfter}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:if>
                </c:forEach>
                <c:if test="${empty txHistory}"><tr><td colspan="5" class="px-5 py-10 text-center text-gray-400 text-xs">No transactions yet.</td></tr></c:if>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
