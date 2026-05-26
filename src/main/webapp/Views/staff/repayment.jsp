<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Record Repayment - SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-6xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Record Loan Repayment</h1>
        <p class="text-gray-500 text-sm mb-6">Record monthly instalments and review repayment history</p>

        <c:if test="${param.msg == 'repaid'}">
            <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-5 text-sm">Repayment recorded successfully.</div>
        </c:if>

        <c:set var="memberSearchTitle" value="Find member"/>
        <c:set var="memberSearchPage" value="repayment"/>
        <c:set var="memberSearchPlaceholder" value="Search member by name, phone, or citizenship..."/>
        <c:set var="memberSearchInputRingClass" value="focus:ring-amber-400"/>
        <c:set var="memberSearchButtonClass" value="bg-amber-500 hover:bg-amber-600"/>
        <c:set var="memberSearchSelectButtonClass" value="bg-amber-100 text-amber-700"/>
        <c:set var="memberSearchSelectButtonHoverClass" value="hover:bg-amber-200"/>
        <jsp:include page="/Views/staff/_member_search_select.jsp"/>

        <c:if test="${member != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-5 mb-5 flex items-center justify-between gap-4">
                <div class="flex items-center gap-4">
                    <div class="w-11 h-11 rounded-xl bg-amber-100 flex items-center justify-center text-amber-700 font-bold text-lg uppercase">${member.fullName.substring(0,1)}</div>
                    <div>
                        <div class="font-bold text-gray-900">${member.fullName}</div>
                        <div class="text-xs text-gray-500">${member.phone}</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/staff?page=repayment" class="text-xs font-semibold bg-gray-100 text-gray-700 px-3 py-2 rounded-lg hover:bg-gray-200 transition">Clear Member</a>
            </div>

            <c:choose>
                <c:when test="${empty loans}">
                    <div class="bg-white rounded-2xl border border-gray-100 p-10 text-center text-gray-400 text-sm mb-6">This member has no active loans.</div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-4 mb-6">
                        <c:forEach var="loan" items="${loans}">
                            <c:if test="${loan.status == 'DISBURSED'}">
                                <c:set var="nextDue" value="${nextDueByLoan[loan.id]}"/>
                                <div class="bg-white rounded-2xl border border-gray-100 p-5">
                                    <div class="flex items-center justify-between mb-4">
                                        <div>
                                            <span class="text-sm font-bold text-gray-900">Loan #${loan.id}</span>
                                            <span class="text-xs text-gray-500 ml-2">Rs. <fmt:formatNumber value="${loan.amount}" pattern="#,##0"/> - ${loan.durationMonths} months</span>
                                        </div>
                                        <span class="inline-block bg-green-100 text-green-700 text-xs font-bold px-2.5 py-1 rounded-full">ACTIVE</span>
                                    </div>
                                    <c:choose>
                                        <c:when test="${nextDue != null}">
                                            <form action="${pageContext.request.contextPath}/transaction" method="post" class="space-y-3">
                                                <input type="hidden" name="action" value="repayment">
                                                <input type="hidden" name="loanId" value="${loan.id}">
                                                <input type="hidden" name="memberId" value="${member.id}">
                                                <input type="hidden" name="repaymentId" value="${nextDue.id}">
                                                <div class="rounded-xl border border-amber-100 bg-amber-50 px-4 py-3 text-xs text-amber-700">
                                                    Next instalment #${nextDue.instalmentNo} due on <fmt:formatDate value="${nextDue.dueDate}" pattern="dd MMM yyyy"/>.
                                                </div>
                                                <div>
                                                    <label class="block text-xs font-semibold text-gray-600 mb-1">Amount Paid (Rs.) - Due: Rs. <fmt:formatNumber value="${nextDue.dueAmount}" pattern="#,##0.00"/></label>
                                                    <input type="number" name="amount" min="1" step="0.01" required
                                                           value="${nextDue.dueAmount}" placeholder="0.00"
                                                           class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 bg-gray-50">
                                                </div>
                                                <button type="submit" class="bg-amber-500 hover:bg-amber-600 text-white font-bold py-2.5 px-6 rounded-xl text-sm transition">
                                                    Record Payment
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-xl border border-green-100 bg-green-50 px-4 py-3 text-sm text-green-700 font-semibold">
                                                All instalments for this loan are already paid.
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <div class="bg-white rounded-2xl border border-gray-100 p-6">
            <h2 class="text-lg font-bold text-gray-900 mb-4">Recent Loan Repayments</h2>
            <div class="overflow-x-auto">
                <table class="w-full text-sm min-w-[700px]">
                    <thead>
                        <tr class="text-left bg-gray-50 text-gray-600">
                            <th class="px-4 py-3 font-semibold">Date</th>
                            <th class="px-4 py-3 font-semibold">Member</th>
                            <th class="px-4 py-3 font-semibold">Amount</th>
                            <th class="px-4 py-3 font-semibold">Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty repaymentHistory}">
                                <c:forEach var="txn" items="${repaymentHistory}">
                                    <tr class="border-b border-gray-100 hover:bg-amber-50 transition">
                                        <td class="px-4 py-3 text-gray-600"><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy HH:mm"/></td>
                                        <td class="px-4 py-3 font-medium text-gray-900">${txn.memberName}</td>
                                        <td class="px-4 py-3 font-bold text-amber-700">Rs. <fmt:formatNumber value="${txn.amount}" pattern="#,##0.00"/></td>
                                        <td class="px-4 py-3 text-gray-600">${txn.description}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4" class="px-4 py-6 text-center text-gray-400">No repayment records found.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
