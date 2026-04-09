<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/member/my-loans.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My Loans — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">

        <div class="flex items-center justify-between mb-6">
            <h1 class="text-2xl font-bold text-gray-900">My Loans</h1>
            <a href="${pageContext.request.contextPath}/member?page=apply-loan" class="bg-green-700 text-white text-xs font-bold px-4 py-2 rounded-xl hover:bg-green-800 transition">+ Apply for Loan</a>
        </div>

        <c:if test="${param.msg == 'applied'}">
            <div class="bg-green-50 border border-green-200 text-green-700 rounded-xl px-4 py-3 mb-4 text-sm">✅ Loan application submitted. Awaiting Admin approval.</div>
        </c:if>

        <c:choose>
            <c:when test="${empty loans}">
                <div class="bg-white rounded-2xl border border-gray-100 p-16 text-center">
                    <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <p class="text-gray-600 font-semibold">No loans yet</p>
                    <p class="text-gray-400 text-sm mt-1">Apply for your first loan below.</p>
                    <a href="${pageContext.request.contextPath}/member?page=apply-loan" class="inline-block mt-4 bg-green-700 text-white text-sm font-bold px-5 py-2.5 rounded-xl hover:bg-green-800 transition">Apply Now →</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="space-y-4">
                    <c:forEach var="l" items="${loans}">
                        <div class="bg-white rounded-2xl border border-gray-100 p-6">
                            <div class="flex items-start justify-between mb-4">
                                <div>
                                    <h3 class="font-bold text-gray-900">Loan #${l.id}</h3>
                                    <p class="text-xs text-gray-500 mt-0.5">${l.purpose}</p>
                                </div>
                                <c:choose>
                                    <c:when test="${l.status == 'PENDING'}">  <span class="bg-amber-100 text-amber-700 text-xs font-bold px-3 py-1.5 rounded-full">PENDING REVIEW</span></c:when>
                                    <c:when test="${l.status == 'APPROVED'}"> <span class="bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1.5 rounded-full">APPROVED</span></c:when>
                                    <c:when test="${l.status == 'DISBURSED'}"><span class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1.5 rounded-full">ACTIVE</span></c:when>
                                    <c:when test="${l.status == 'CLOSED'}">  <span class="bg-gray-100 text-gray-500 text-xs font-bold px-3 py-1.5 rounded-full">CLOSED</span></c:when>
                                    <c:otherwise>                            <span class="bg-red-100 text-red-600 text-xs font-bold px-3 py-1.5 rounded-full">REJECTED</span></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                <div><p class="text-xs text-gray-400">Amount</p><p class="text-sm font-bold text-gray-900">Rs. <fmt:formatNumber value="${l.amount}" pattern="#,##0"/></p></div>
                                <div><p class="text-xs text-gray-400">Monthly EMI</p><p class="text-sm font-bold text-gray-900">Rs. <fmt:formatNumber value="${l.monthlyEmi}" pattern="#,##0.00"/></p></div>
                                <div><p class="text-xs text-gray-400">Duration</p><p class="text-sm font-bold text-gray-900">${l.durationMonths} months</p></div>
                                <div><p class="text-xs text-gray-400">Interest</p><p class="text-sm font-bold text-gray-900">${l.interestRate}% p.a.</p></div>
                            </div>
                            <c:if test="${l.status == 'DISBURSED'}">
                                <div class="mt-4 pt-4 border-t border-gray-100">
                                    <a href="${pageContext.request.contextPath}/member?page=repayment-schedule&loanId=${l.id}" class="text-xs text-green-700 font-semibold hover:underline">View repayment schedule →</a>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div></div>
</body></html>
