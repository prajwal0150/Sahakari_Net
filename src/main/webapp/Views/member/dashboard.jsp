<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/member/dashboard.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My Dashboard — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-5xl mx-auto px-6 py-8">

        <div class="mb-8">
            <h1 class="text-2xl font-bold text-gray-900">My Dashboard</h1>
            <c:if test="${member != null}">
                <p class="text-gray-500 text-sm mt-1">Welcome back, <strong>${member.fullName}</strong></p>
            </c:if>
        </div>

        <!-- Key stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-gradient-to-br from-green-700 to-green-900 rounded-2xl p-6 text-white">
                <div class="text-xs font-semibold text-green-200 uppercase tracking-wide mb-2">Savings Balance</div>
                <div class="text-3xl font-extrabold">
                    <c:choose>
                        <c:when test="${savings != null}">Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></c:when>
                        <c:otherwise>Rs. 0.00</c:otherwise>
                    </c:choose>
                </div>
                <div class="text-xs text-green-300 mt-1">
                    <c:if test="${savings != null}">Share capital: Rs. <fmt:formatNumber value="${savings.shareCapital}" pattern="#,##0"/></c:if>
                </div>
                <a href="${pageContext.request.contextPath}/member?page=savings" class="inline-block mt-4 text-xs font-semibold text-white underline">View details →</a>
            </div>

            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Active Loans</div>
                <c:set var="activeCount" value="0"/>
                <c:forEach var="l" items="${loans}">
                    <c:if test="${l.status == 'DISBURSED'}"><c:set var="activeCount" value="${activeCount + 1}"/></c:if>
                </c:forEach>
                <div class="text-3xl font-extrabold text-gray-900">${activeCount}</div>
                <div class="text-xs text-gray-400 mt-1">Running loans</div>
                <a href="${pageContext.request.contextPath}/member?page=my-loans" class="inline-block mt-4 text-xs font-semibold text-green-700 hover:underline">View loans →</a>
            </div>

            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <div class="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">Interest Rate</div>
                <div class="text-3xl font-extrabold text-gray-900">
                    <c:choose>
                        <c:when test="${savings != null}">${savings.interestRate}%</c:when>
                        <c:otherwise>6.00%</c:otherwise>
                    </c:choose>
                </div>
                <div class="text-xs text-gray-400 mt-1">Annual savings interest</div>
                <a href="${pageContext.request.contextPath}/member?page=apply-loan" class="inline-block mt-4 text-xs font-semibold text-green-700 hover:underline">Apply for loan →</a>
            </div>
        </div>

        <!-- Recent transactions -->
        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden mb-6">
            <div class="px-5 py-4 border-b border-gray-100 flex items-center justify-between">
                <h2 class="text-sm font-bold text-gray-700">Recent Transactions</h2>
                <a href="${pageContext.request.contextPath}/member?page=transactions" class="text-xs text-green-700 font-semibold hover:underline">View all →</a>
            </div>
            <c:choose>
                <c:when test="${empty recentTx}">
                    <div class="px-5 py-10 text-center text-gray-400 text-sm">No transactions yet.</div>
                </c:when>
                <c:otherwise>
                    <table class="w-full text-sm">
                        <tbody class="divide-y divide-gray-50">
                        <c:forEach var="t" items="${recentTx}">
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
                                <td class="px-5 py-3.5 text-xs text-gray-500">${t.description}</td>
                                <td class="px-5 py-3.5 text-xs font-bold text-gray-900 text-right">Rs. <fmt:formatNumber value="${t.amount}" pattern="#,##0.00"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Loan status cards -->
        <c:if test="${not empty loans}">
            <div class="bg-white rounded-2xl border border-gray-100 p-5">
                <h2 class="text-sm font-bold text-gray-700 mb-4">My Loans</h2>
                <div class="space-y-3">
                    <c:forEach var="l" items="${loans}">
                        <div class="flex items-center justify-between p-3 bg-gray-50 rounded-xl">
                            <div>
                                <div class="text-xs font-bold text-gray-900">Loan #${l.id} &bull; Rs. <fmt:formatNumber value="${l.amount}" pattern="#,##0"/></div>
                                <div class="text-xs text-gray-500 mt-0.5">${l.purpose}</div>
                            </div>
                            <c:choose>
                                <c:when test="${l.status == 'PENDING'}">  <span class="text-xs font-semibold bg-amber-100 text-amber-700 px-2.5 py-1 rounded-full">Pending</span></c:when>
                                <c:when test="${l.status == 'APPROVED'}"> <span class="text-xs font-semibold bg-blue-100 text-blue-700 px-2.5 py-1 rounded-full">Approved</span></c:when>
                                <c:when test="${l.status == 'DISBURSED'}"><a href="${pageContext.request.contextPath}/member?page=repayment-schedule&loanId=${l.id}" class="text-xs font-semibold bg-green-100 text-green-700 px-2.5 py-1 rounded-full hover:underline">Active →</a></c:when>
                                <c:when test="${l.status == 'CLOSED'}">  <span class="text-xs font-semibold bg-gray-100 text-gray-500 px-2.5 py-1 rounded-full">Closed</span></c:when>
                                <c:otherwise>                            <span class="text-xs font-semibold bg-red-100 text-red-600 px-2.5 py-1 rounded-full">Rejected</span></c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

    </div></div>
</body></html>
