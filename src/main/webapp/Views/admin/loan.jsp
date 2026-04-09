<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/admin/loans.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Loans — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">

        <div class="flex items-center justify-between mb-6">
            <div><h1 class="text-2xl font-bold text-gray-900">Loans</h1>
                <p class="text-gray-500 text-sm mt-0.5">All loan applications and their status</p></div>
        </div>

        <!-- Status filter tabs -->
        <div class="flex gap-2 mb-6 flex-wrap">
            <c:set var="ctx" value="${pageContext.request.contextPath}"/>
            <a href="${ctx}/admin?page=loans" class="text-xs font-semibold px-4 py-2 rounded-full border ${empty filterStatus ? 'bg-gray-900 text-white border-gray-900' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">All</a>
            <a href="${ctx}/admin?page=loans&status=PENDING"   class="text-xs font-semibold px-4 py-2 rounded-full border ${'PENDING'   == filterStatus ? 'bg-amber-600 text-white border-amber-600' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">Pending</a>
            <a href="${ctx}/admin?page=loans&status=APPROVED"  class="text-xs font-semibold px-4 py-2 rounded-full border ${'APPROVED'  == filterStatus ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">Approved</a>
            <a href="${ctx}/admin?page=loans&status=DISBURSED" class="text-xs font-semibold px-4 py-2 rounded-full border ${'DISBURSED' == filterStatus ? 'bg-green-700 text-white border-green-700' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">Disbursed</a>
            <a href="${ctx}/admin?page=loans&status=CLOSED"    class="text-xs font-semibold px-4 py-2 rounded-full border ${'CLOSED'    == filterStatus ? 'bg-gray-600 text-white border-gray-600' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">Closed</a>
            <a href="${ctx}/admin?page=loans&status=REJECTED"  class="text-xs font-semibold px-4 py-2 rounded-full border ${'REJECTED'  == filterStatus ? 'bg-red-600 text-white border-red-600' : 'bg-white text-gray-600 border-gray-200 hover:border-gray-400'}">Rejected</a>
        </div>

        <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-gray-50 border-b border-gray-100">
                <tr>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">#</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Member</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Amount</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden md:table-cell">Purpose</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide hidden lg:table-cell">EMI / Month</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Status</th>
                    <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Action</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                <c:choose>
                    <c:when test="${empty loans}">
                        <tr><td colspan="7" class="px-5 py-10 text-center text-gray-400 text-sm">No loans found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="l" items="${loans}">
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-5 py-3.5 text-xs text-gray-400 font-mono">#${l.id}</td>
                                <td class="px-5 py-3.5">
                                    <div class="font-semibold text-gray-900 text-xs">${l.memberName}</div>
                                    <div class="text-gray-400 text-xs">${l.memberPhone}</div>
                                </td>
                                <td class="px-5 py-3.5 font-bold text-gray-900 text-xs">Rs. <fmt:formatNumber value="${l.amount}" pattern="#,##0"/></td>
                                <td class="px-5 py-3.5 text-gray-600 text-xs hidden md:table-cell max-w-xs truncate">${l.purpose}</td>
                                <td class="px-5 py-3.5 text-gray-600 text-xs hidden lg:table-cell">Rs. <fmt:formatNumber value="${l.monthlyEmi}" pattern="#,##0.00"/></td>
                                <td class="px-5 py-3.5">
                                    <c:choose>
                                        <c:when test="${l.status == 'PENDING'}">  <span class="inline-block bg-amber-100 text-amber-700 text-xs font-semibold px-2.5 py-1 rounded-full">Pending</span></c:when>
                                        <c:when test="${l.status == 'APPROVED'}"> <span class="inline-block bg-blue-100 text-blue-700 text-xs font-semibold px-2.5 py-1 rounded-full">Approved</span></c:when>
                                        <c:when test="${l.status == 'DISBURSED'}"><span class="inline-block bg-green-100 text-green-700 text-xs font-semibold px-2.5 py-1 rounded-full">Disbursed</span></c:when>
                                        <c:when test="${l.status == 'CLOSED'}">  <span class="inline-block bg-gray-100 text-gray-600 text-xs font-semibold px-2.5 py-1 rounded-full">Closed</span></c:when>
                                        <c:otherwise>                             <span class="inline-block bg-red-100 text-red-600 text-xs font-semibold px-2.5 py-1 rounded-full">Rejected</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-5 py-3.5">
                                    <a href="${ctx}/admin?page=loan-detail&id=${l.id}" class="text-xs text-green-700 font-semibold hover:underline">View →</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div></div>
</body></html>
