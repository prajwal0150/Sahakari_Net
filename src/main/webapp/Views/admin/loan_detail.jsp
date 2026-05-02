<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/admin/loan-detail.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Loan Detail — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-4xl mx-auto px-6 py-8">

        <a href="${pageContext.request.contextPath}/admin?page=loans" class="inline-flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
            Back to Loans
        </a>

        <c:if test="${param.msg == 'approved'}">
            <div class="bg-green-50 border border-green-200 text-green-800 rounded-xl px-4 py-3 mb-4 text-sm">✅ Loan approved successfully.</div>
        </c:if>

        <c:if test="${loan != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-7 mb-5">
                <div class="flex items-start justify-between mb-6">
                    <div>
                        <h1 class="text-xl font-bold text-gray-900">Loan #${loan.id}</h1>
                        <p class="text-gray-500 text-sm mt-0.5">${loan.memberName} &bull; ${loan.memberPhone}</p>
                    </div>
                    <c:choose>
                        <c:when test="${loan.status == 'PENDING'}">  <span class="bg-amber-100 text-amber-700 text-xs font-bold px-3 py-1.5 rounded-full">PENDING REVIEW</span></c:when>
                        <c:when test="${loan.status == 'APPROVED'}"> <span class="bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1.5 rounded-full">APPROVED</span></c:when>
                        <c:when test="${loan.status == 'DISBURSED'}"><span class="bg-green-100 text-green-700 text-xs font-bold px-3 py-1.5 rounded-full">DISBURSED</span></c:when>
                        <c:when test="${loan.status == 'CLOSED'}">  <span class="bg-gray-100 text-gray-600 text-xs font-bold px-3 py-1.5 rounded-full">CLOSED</span></c:when>
                        <c:otherwise>                               <span class="bg-red-100 text-red-600 text-xs font-bold px-3 py-1.5 rounded-full">REJECTED</span></c:otherwise>
                    </c:choose>
                </div>

                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
                    <div class="bg-gray-50 rounded-xl p-4">
                        <div class="text-xs text-gray-400 mb-1">Loan Amount</div>
                        <div class="text-lg font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${loan.amount}" pattern="#,##0"/></div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4">
                        <div class="text-xs text-gray-400 mb-1">Monthly EMI</div>
                        <div class="text-lg font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${loan.monthlyEmi}" pattern="#,##0.00"/></div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4">
                        <div class="text-xs text-gray-400 mb-1">Interest Rate</div>
                        <div class="text-lg font-extrabold text-gray-900">${loan.interestRate}% p.a.</div>
                    </div>
                    <div class="bg-gray-50 rounded-xl p-4">
                        <div class="text-xs text-gray-400 mb-1">Duration</div>
                        <div class="text-lg font-extrabold text-gray-900">${loan.durationMonths} months</div>
                    </div>
                </div>

                <div class="border-t border-gray-100 pt-5">
                    <div class="text-xs text-gray-400 mb-1">Purpose</div>
                    <p class="text-sm text-gray-700">${loan.purpose}</p>
                </div>

                <!-- Approve / Reject buttons — only for PENDING -->
                <c:if test="${loan.status == 'PENDING'}">
                    <div class="flex gap-3 mt-6 pt-6 border-t border-gray-100">
                        <form action="${pageContext.request.contextPath}/admin" method="post">
                            <input type="hidden" name="action" value="approve-loan">
                            <input type="hidden" name="loanId" value="${loan.id}">
                            <button type="submit" class="bg-green-700 text-white text-sm font-bold px-6 py-2.5 rounded-xl hover:bg-green-800 transition">✓ Approve Loan</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin" method="post">
                            <input type="hidden" name="action" value="reject-loan">
                            <input type="hidden" name="loanId" value="${loan.id}">
                            <button type="submit" class="bg-red-50 text-red-600 border border-red-200 text-sm font-bold px-6 py-2.5 rounded-xl hover:bg-red-100 transition">✕ Reject Loan</button>
                        </form>
                    </div>
                </c:if>
            </div>
        </c:if>

    </div></div>
</body></html>
