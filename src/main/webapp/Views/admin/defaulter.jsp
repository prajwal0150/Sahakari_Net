<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/admin/defaulters.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Defaulters — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">

        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Loan Defaulters</h1>
            <p class="text-gray-500 text-sm mt-0.5">Members with overdue loan repayments</p>
        </div>

        <c:if test="${empty defaulters}">
            <div class="bg-white rounded-2xl border border-gray-100 p-16 text-center">
                <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <p class="text-gray-600 font-semibold">No defaulters found</p>
                <p class="text-gray-400 text-sm mt-1">All loan repayments are up to date.</p>
            </div>
        </c:if>

        <c:if test="${not empty defaulters}">
            <div class="bg-red-50 border border-red-200 rounded-2xl p-4 mb-5 flex items-center gap-3">
                <svg class="w-5 h-5 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <p class="text-red-700 text-sm font-semibold">${defaulters.size()} overdue instalment(s) found. Follow up with members immediately.</p>
            </div>

            <div class="bg-white rounded-2xl border border-gray-100 overflow-hidden">
                <table class="w-full text-sm">
                    <thead class="bg-gray-50 border-b border-gray-100">
                    <tr>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Member</th>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Loan #</th>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Instalment</th>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Due Date</th>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Amount Due</th>
                        <th class="text-left px-5 py-3.5 text-xs font-semibold text-gray-500 uppercase tracking-wide">Status</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                    <c:forEach var="d" items="${defaulters}">
                        <tr class="hover:bg-red-50 transition">
                            <td class="px-5 py-3.5">
                                <div class="font-semibold text-gray-900 text-xs">${d.memberName}</div>
                                <div class="text-gray-400 text-xs">${d.memberPhone}</div>
                            </td>
                            <td class="px-5 py-3.5 text-xs text-gray-600 font-mono">#${d.loanId}</td>
                            <td class="px-5 py-3.5 text-xs text-gray-600">No. ${d.instalmentNo}</td>
                            <td class="px-5 py-3.5 text-xs text-red-600 font-semibold">${d.dueDate}</td>
                            <td class="px-5 py-3.5 text-xs font-bold text-gray-900">Rs. <fmt:formatNumber value="${d.dueAmount}" pattern="#,##0.00"/></td>
                            <td class="px-5 py-3.5"><span class="inline-block bg-red-100 text-red-700 text-xs font-bold px-2.5 py-1 rounded-full">OVERDUE</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

    </div></div>
</body></html>
