<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/staff/member-detail.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Member Detail — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">

        <c:if test="${param.msg == 'deposited'}"><div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-4 text-sm">✅ Deposit recorded.</div></c:if>
        <c:if test="${param.msg == 'withdrawn'}"><div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-4 text-sm">✅ Withdrawal recorded.</div></c:if>

        <c:if test="${member != null}">
            <!-- Member header -->
            <div class="bg-white rounded-2xl border border-gray-100 p-6 mb-5">
                <div class="flex items-center justify-between flex-wrap gap-4">
                    <div class="flex items-center gap-4">
                        <div class="w-14 h-14 rounded-2xl bg-green-100 flex items-center justify-center text-green-700 font-extrabold text-2xl uppercase">${member.fullName.substring(0,1)}</div>
                        <div>
                            <h1 class="text-xl font-bold text-gray-900">${member.fullName}</h1>
                            <p class="text-xs text-gray-500 mt-0.5">${member.phone} &bull; <span class="font-mono">${member.citizenshipNo}</span></p>
                        </div>
                    </div>
                    <div class="flex gap-2">
                        <a href="${pageContext.request.contextPath}/staff?page=deposit&memberId=${member.id}"    class="text-xs font-bold bg-green-100 text-green-700 px-4 py-2 rounded-xl hover:bg-green-200 transition">+ Deposit</a>
                        <a href="${pageContext.request.contextPath}/staff?page=withdrawal&memberId=${member.id}" class="text-xs font-bold bg-red-100 text-red-600 px-4 py-2 rounded-xl hover:bg-red-200 transition">- Withdraw</a>
                        <a href="${pageContext.request.contextPath}/staff?page=repayment&memberId=${member.id}"  class="text-xs font-bold bg-amber-100 text-amber-700 px-4 py-2 rounded-xl hover:bg-amber-200 transition">↻ Repayment</a>
                    </div>
                </div>
            </div>

            <!-- Savings balance -->
            <c:if test="${savings != null}">
                <div class="grid grid-cols-3 gap-4 mb-5">
                    <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center">
                        <div class="text-xs text-gray-400 mb-1">Savings Balance</div>
                        <div class="text-2xl font-extrabold text-green-700">Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center">
                        <div class="text-xs text-gray-400 mb-1">Share Capital</div>
                        <div class="text-2xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${savings.shareCapital}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="bg-white rounded-2xl border border-gray-100 p-5 text-center">
                        <div class="text-xs text-gray-400 mb-1">Interest Rate</div>
                        <div class="text-2xl font-extrabold text-gray-900">${savings.interestRate}%</div>
                    </div>
                </div>
            </c:if>

            <!-- Recent transactions -->
            <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
                <div class="px-5 py-4 border-b border-gray-100"><h2 class="text-sm font-bold text-gray-700">Recent Transactions</h2></div>
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-b border-gray-100">
                    <tr>
                        <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Date</th>
                        <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Type</th>
                        <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Amount</th>
                        <th class="text-left px-5 py-3 text-xs font-semibold text-gray-500 uppercase">Balance</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                    <c:forEach var="t" items="${recentTx}">
                        <tr class="hover:bg-gray-50">
                            <td class="px-5 py-3 text-xs text-gray-500">${t.transactionDate}</td>
                            <td class="px-5 py-3">
                                <c:choose>
                                    <c:when test="${t.type == 'DEPOSIT'}">       <span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2 py-0.5 rounded-full">Deposit</span></c:when>
                                    <c:when test="${t.type == 'WITHDRAWAL'}">    <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2 py-0.5 rounded-full">Withdrawal</span></c:when>
                                    <c:when test="${t.type == 'LOAN_DISBURSE'}"> <span class="inline-block bg-blue-100 text-blue-700 text-xs font-semibold px-2 py-0.5 rounded-full">Loan</span></c:when>
                                    <c:otherwise>                                <span class="inline-block bg-amber-100 text-amber-700 text-xs font-semibold px-2 py-0.5 rounded-full">Repayment</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="px-5 py-3 text-xs font-bold text-gray-900">Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
                            <td class="px-5 py-3 text-xs text-gray-500">Rs. <fmt:formatNumber value="${t.balanceAfter}" pattern="#,##0.00"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentTx}"><tr><td colspan="4" class="px-5 py-8 text-center text-gray-400 text-xs">No transactions.</td></tr></c:if>
                    </tbody>
                </table>
            </div>
        </c:if>

    </div></div>
</body></html>
