<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <div class="max-w-2xl mx-auto px-6 py-8">
        <a href="${pageContext.request.contextPath}/staff?page=search" class="inline-flex items-center gap-1 text-xs text-gray-500 hover:text-gray-700 mb-6">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>Search Member
        </a>
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Record Withdrawal</h1>
        <p class="text-gray-500 text-sm mb-6">Withdraw from member savings account</p>

        <c:if test="${member == null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-6">
                <form action="${pageContext.request.contextPath}/staff" method="get" class="flex gap-3">
                    <input type="hidden" name="page" value="withdrawal">
                    <input type="text" name="q" placeholder="Search by name, phone, citizenship..." autofocus
                           class="flex-1 border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-green-500 bg-gray-50">
                    <button type="submit" class="bg-green-700 text-white px-5 py-2.5 rounded-xl text-sm font-semibold">Find</button>
                </form>
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
