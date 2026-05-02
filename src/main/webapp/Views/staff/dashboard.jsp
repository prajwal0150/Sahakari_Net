<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/staff/dashboard.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Staff Dashboard — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">

        <div class="mb-8">
            <h1 class="text-2xl font-bold text-gray-900">Staff Dashboard</h1>
            <p class="text-gray-500 text-sm mt-1">Welcome, <strong>${sessionScope.username}</strong>. Manage member transactions below.</p>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                </div>
                <div><div class="text-2xl font-extrabold text-gray-900">${todayCount}</div><div class="text-xs text-gray-400">Your transactions today</div></div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                </div>
                <div><div class="text-2xl font-extrabold text-gray-900">${totalMembers}</div><div class="text-xs text-gray-400">Total approved members</div></div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-amber-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-amber-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div><div class="text-2xl font-extrabold text-gray-900">${activeLoans}</div><div class="text-xs text-gray-400">Active loans</div></div>
            </div>
        </div>

        <!-- Quick actions -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
            <a href="${pageContext.request.contextPath}/staff?page=deposit" class="bg-white rounded-2xl border border-gray-100 p-5 flex flex-col items-center gap-3 hover:border-green-300 hover:bg-green-50 transition text-center card-hover">
                <div class="w-11 h-11 bg-green-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg></div>
                <span class="text-xs font-bold text-gray-700">Record Deposit</span>
            </a>
            <a href="${pageContext.request.contextPath}/staff?page=withdrawal" class="bg-white rounded-2xl border border-gray-100 p-5 flex flex-col items-center gap-3 hover:border-red-300 hover:bg-red-50 transition text-center">
                <div class="w-11 h-11 bg-red-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg></div>
                <span class="text-xs font-bold text-gray-700">Record Withdrawal</span>
            </a>
            <a href="${pageContext.request.contextPath}/staff?page=loan-disburse" class="bg-white rounded-2xl border border-gray-100 p-5 flex flex-col items-center gap-3 hover:border-blue-300 hover:bg-blue-50 transition text-center">
                <div class="w-11 h-11 bg-blue-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/></svg></div>
                <span class="text-xs font-bold text-gray-700">Disburse Loan</span>
            </a>
            <a href="${pageContext.request.contextPath}/staff?page=repayment" class="bg-white rounded-2xl border border-gray-100 p-5 flex flex-col items-center gap-3 hover:border-amber-300 hover:bg-amber-50 transition text-center">
                <div class="w-11 h-11 bg-amber-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-amber-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg></div>
                <span class="text-xs font-bold text-gray-700">Record Repayment</span>
            </a>
        </div>

        <!-- Recent transactions -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100"><h2 class="text-sm font-bold text-gray-700">Recent Transactions</h2></div>
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Date</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Member</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Type</th>
                    <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Amount</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:forEach var="t" items="${recentTx}">
                    <tr class="hover:bg-gray-50">
                        <td class="px-5 py-3 text-xs text-gray-500">${t.transactionDate}</td>
                        <td class="px-5 py-3 text-xs font-semibold text-gray-900">${t.memberName}</td>
                        <td class="px-5 py-3">
                            <c:choose>
                                <c:when test="${t.type == 'DEPOSIT'}">       <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2 py-0.5 rounded-full">Deposit</span></c:when>
                                <c:when test="${t.type == 'WITHDRAWAL'}">    <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Withdrawal</span></c:when>
                                <c:when test="${t.type == 'LOAN_DISBURSE'}"> <span class="inline-block bg-blue-100 text-blue-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan</span></c:when>
                                <c:otherwise>                                <span class="inline-block bg-amber-100 text-amber-700 text-xs font-semibold px-2 py-0.5 rounded-full">Repayment</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="px-5 py-3 text-xs font-bold text-gray-900">Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty recentTx}">
                    <tr><td colspan="4" class="px-5 py-8 text-center text-gray-400 text-xs">No transactions yet today.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>

    </div></div>
</body></html>
