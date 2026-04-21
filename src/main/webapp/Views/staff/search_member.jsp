<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Search Member - SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-6xl mx-auto px-6 py-8">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Search Member</h1>
            <p class="text-gray-500 text-sm mt-0.5">Search by name, phone number, or citizenship number</p>
        </div>
        <form action="${pageContext.request.contextPath}/staff" method="get" class="flex gap-3 mb-6 flex-col sm:flex-row">
            <input type="hidden" name="page" value="search">
            <input type="text" name="q" value="${q}" autofocus placeholder="Search member..."
                   class="flex-1 border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
            <button type="submit" class="bg-green-700 text-white px-6 py-3 rounded-xl text-sm font-semibold hover:bg-green-800 transition">Search</button>
        </form>

        <c:if test="${q != null && !q.isEmpty()}">
            <c:choose>
                <c:when test="${empty members}">
                    <div class="bg-white rounded-2xl border border-gray-100 p-12 text-center">
                        <p class="text-gray-400 text-sm">No members found for "<strong>${q}</strong>"</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-3">
                        <c:forEach var="m" items="${members}">
                            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center justify-between">
                                <div class="flex items-center gap-4">
                                    <div class="w-11 h-11 rounded-xl bg-green-100 flex items-center justify-center text-green-700 font-bold text-lg uppercase">${m.fullName.substring(0,1)}</div>
                                    <div>
                                        <div class="font-bold text-gray-900 text-sm">${m.fullName}</div>
                                        <div class="text-xs text-gray-500 mt-0.5">${m.phone} &bull; <span class="font-mono">${m.citizenshipNo}</span></div>
                                    </div>
                                </div>
                                <div class="flex gap-2 flex-wrap justify-end">
                                    <a href="${pageContext.request.contextPath}/staff?page=deposit&memberId=${m.id}"    class="text-xs font-semibold bg-green-100 text-green-700 px-3 py-1.5 rounded-lg hover:bg-green-200 transition">Deposit</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=withdrawal&memberId=${m.id}" class="text-xs font-semibold bg-red-100 text-red-600 px-3 py-1.5 rounded-lg hover:bg-red-200 transition">Withdraw</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=repayment&memberId=${m.id}" class="text-xs font-semibold bg-amber-100 text-amber-700 px-3 py-1.5 rounded-lg hover:bg-amber-200 transition">Repayment</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=loan-disburse&memberId=${m.id}" class="text-xs font-semibold bg-blue-100 text-blue-700 px-3 py-1.5 rounded-lg hover:bg-blue-200 transition">Loan View</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=search&memberId=${m.id}&q=${q}" class="text-xs font-semibold bg-slate-100 text-slate-700 px-3 py-1.5 rounded-lg hover:bg-slate-200 transition">History</a>
                                    <a href="${pageContext.request.contextPath}/staff?page=member-detail&id=${m.id}"   class="text-xs font-semibold bg-gray-100 text-gray-700 px-3 py-1.5 rounded-lg hover:bg-gray-200 transition">View →</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <c:if test="${selectedMember != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-6 mt-6">
                <div class="flex items-center justify-between mb-4 gap-3">
                    <h2 class="text-lg font-bold text-gray-900">Transaction History - ${selectedMember.fullName}</h2>
                    <a href="${pageContext.request.contextPath}/staff?page=search&q=${q}" class="text-xs font-semibold bg-gray-100 text-gray-700 px-3 py-1.5 rounded-lg hover:bg-gray-200 transition">Clear History</a>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm min-w-[760px]">
                        <thead>
                            <tr class="text-left bg-gray-50 text-gray-600">
                                <th class="px-4 py-3 font-semibold">Date</th>
                                <th class="px-4 py-3 font-semibold">Type</th>
                                <th class="px-4 py-3 font-semibold">Amount</th>
                                <th class="px-4 py-3 font-semibold">Description</th>
                                <th class="px-4 py-3 font-semibold">Recorded By</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty searchMemberHistory}">
                                    <c:forEach var="txn" items="${searchMemberHistory}">
                                        <tr class="border-b border-gray-100 hover:bg-gray-50 transition">
                                            <td class="px-4 py-3 text-gray-600"><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                            <td class="px-4 py-3 font-medium text-gray-900">${txn.type}</td>
                                            <td class="px-4 py-3 font-semibold text-gray-800">Rs. <fmt:formatNumber value="${txn.amount}" pattern="#,##0.00"/></td>
                                            <td class="px-4 py-3 text-gray-600">${txn.description}</td>
                                            <td class="px-4 py-3 text-gray-600">${txn.recordedByName}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="px-4 py-6 text-center text-gray-400">No transaction history found for this member.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div></div>
</body>
</html>
