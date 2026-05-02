<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/staff/withdrawal.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Record Withdrawal — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-6xl mx-auto px-6 py-8">
        <a href="${pageContext.request.contextPath}/staff?page=search" class="inline-flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>Search Member
        </a>
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Record Withdrawal</h1>
        <p class="text-gray-500 text-sm mb-6">Withdraw from member savings account</p>

        <c:if test="${member == null}">
            <c:set var="memberSearchTitle" value="Find member first"/>
            <c:set var="memberSearchPage" value="withdrawal"/>
            <c:set var="memberSearchPlaceholder" value="Search by name, phone, citizenship..."/>
            <c:set var="memberSearchInputRingClass" value="focus:ring-red-500"/>
            <c:set var="memberSearchButtonClass" value="bg-red-600 hover:bg-red-700"/>
            <c:set var="memberSearchSelectButtonClass" value="bg-red-100 text-red-700"/>
            <c:set var="memberSearchSelectButtonHoverClass" value="hover:bg-red-200"/>
            <jsp:include page="/Views/staff/_member_search_select.jsp"/>

            <!-- Withdrawal History Section -->
            <div class="bg-white rounded-2xl border border-gray-100 p-6 mt-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4">Recent Withdrawals</h2>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm">
                        <thead>
                            <tr class="border-b border-gray-200">
                                <th class="text-left px-4 py-3 font-semibold text-gray-700">Date</th>
                                <th class="text-left px-4 py-3 font-semibold text-gray-700">Member</th>
                                <th class="text-left px-4 py-3 font-semibold text-gray-700">Amount</th>
                                <th class="text-left px-4 py-3 font-semibold text-gray-700">Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty withdrawalHistory}">
                                    <c:forEach var="txn" items="${withdrawalHistory}">
                                        <tr class="border-b border-gray-100 hover:bg-red-50 transition">
                                            <td class="px-4 py-3 text-gray-600"><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                            <td class="px-4 py-3 font-medium text-gray-900">${txn.memberName}</td>
                                            <td class="px-4 py-3 font-bold text-red-600">- Rs. <fmt:formatNumber value="${txn.amount}" pattern="#,##0.00"/></td>
                                            <td class="px-4 py-3 text-gray-600">${txn.description}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="px-4 py-8 text-center text-gray-500">No withdrawals recorded yet</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <c:if test="${member != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-5 mb-5">
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-red-100 flex items-center justify-center text-red-600 font-bold text-xl uppercase">${member.fullName.substring(0,1)}</div>
                    <div>
                        <div class="font-bold text-gray-900">${member.fullName}</div>
                        <div class="text-xs text-gray-500">${member.phone}</div>
                    </div>
                    <c:if test="${savings != null}">
                        <div class="ml-auto text-right">
                            <div class="text-xs text-gray-400">Available Balance</div>
                            <div class="text-lg font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></div>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <c:if test="${error != null}">
                    <div class="bg-red-50 border border-red-200 text-red-700 rounded-xl px-4 py-3 mb-4 text-sm">${error}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/transaction" method="post">
                    <input type="hidden" name="action"   value="withdraw">
                    <input type="hidden" name="memberId" value="${member.id}">
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1.5">Withdrawal Amount (Rs.) <span class="text-red-500">*</span></label>
                            <input type="number" name="amount" min="1" max="${savings != null ? savings.balance : 0}" step="0.01" required placeholder="0.00"
                                   class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-2 focus:ring-red-400 bg-gray-50 text-lg font-bold">
                            <c:if test="${savings != null}"><p class="text-xs text-gray-400 mt-1">Max: Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></p></c:if>
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1.5">Description</label>
                            <input type="text" name="description" placeholder="e.g. Member withdrawal" value="Savings withdrawal"
                                   class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-red-400 bg-gray-50">
                        </div>
                        <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white font-bold py-3.5 rounded-xl text-sm transition">
                            Record Withdrawal
                        </button>
                    </div>
                </form>
            </div>
        </c:if>
    </div></div>
</body></html>
