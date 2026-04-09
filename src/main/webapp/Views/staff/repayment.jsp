<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/staff/repayment.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Record Repayment — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-3xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Record Loan Repayment</h1>
        <p class="text-gray-500 text-sm mb-6">Record a member's monthly loan instalment payment</p>

        <c:if test="${param.msg == 'repaid'}">
            <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-5 text-sm">✅ Repayment recorded successfully.</div>
        </c:if>

        <!-- Search for member -->
        <c:if test="${member == null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-6 mb-5">
                <p class="text-sm font-semibold text-gray-700 mb-3">Find member</p>
                <form action="${pageContext.request.contextPath}/staff" method="get" class="flex gap-3">
                    <input type="hidden" name="page" value="repayment">
                    <input type="text" name="q" placeholder="Search member by name or phone..." autofocus
                           class="flex-1 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                    <button type="submit" class="bg-green-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold">Find</button>
                </form>
            </div>
        </c:if>

        <c:if test="${member != null}">
            <!-- Member header -->
            <div class="bg-white rounded-2xl border border-gray-100 p-5 mb-5 flex items-center gap-4">
                <div class="w-11 h-11 rounded-xl bg-amber-100 flex items-center justify-center text-amber-700 font-bold text-lg uppercase">${member.fullName.substring(0,1)}</div>
                <div>
                    <div class="font-bold text-gray-900">${member.fullName}</div>
                    <div class="text-xs text-gray-500">${member.phone}</div>
                </div>
            </div>

            <!-- Loans with pending instalments -->
            <c:choose>
                <c:when test="${empty loans}">
                    <div class="bg-white rounded-2xl border border-gray-100 p-10 text-center text-gray-400 text-sm">This member has no active loans.</div>
                </c:when>
                <c:otherwise>
                    <div class="space-y-4">
                        <c:forEach var="loan" items="${loans}">
                            <c:if test="${loan.status == 'DISBURSED'}">
                                <div class="bg-white rounded-2xl border border-gray-100 p-5">
                                    <div class="flex items-center justify-between mb-4">
                                        <div>
                                            <span class="text-sm font-bold text-gray-900">Loan #${loan.id}</span>
                                            <span class="text-xs text-gray-500 ml-2">Rs. <fmt:formatNumber value="${loan.amount}" pattern="#,##0"/> &bull; ${loan.durationMonths} months</span>
                                        </div>
                                        <span class="inline-block bg-green-100 text-green-700 text-xs font-bold px-2.5 py-1 rounded-full">ACTIVE</span>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/transaction" method="post" class="space-y-3">
                                        <input type="hidden" name="action"   value="repayment">
                                        <input type="hidden" name="loanId"   value="${loan.id}">
                                        <input type="hidden" name="memberId" value="${member.id}">
                                            <%-- Staff enters repayment ID manually or you can use a dropdown with next due instalment --%>
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-600 mb-1">Repayment ID (from schedule)</label>
                                            <input type="number" name="repaymentId" required placeholder="Enter repayment ID"
                                                   class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 bg-gray-50">
                                        </div>
                                        <div>
                                            <label class="block text-xs font-semibold text-gray-600 mb-1">Amount Paid (Rs.) — EMI: Rs. <fmt:formatNumber value="${loan.monthlyEmi}" pattern="#,##0.00"/></label>
                                            <input type="number" name="amount" min="1" step="0.01" required
                                                   value="${loan.monthlyEmi}" placeholder="0.00"
                                                   class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-amber-400 bg-gray-50">
                                        </div>
                                        <button type="submit" class="bg-amber-500 hover:bg-amber-600 text-white font-bold py-2.5 px-6 rounded-xl text-sm transition">
                                            Record Payment
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

    </div></div>
</body></html>
