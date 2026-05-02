<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- FILE: src/main/webapp/views/admin/dashboard.jsp --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>

<div class="lg:ml-64 min-h-screen">
    <div class="max-w-7xl mx-auto px-6 py-8">

        <!-- Page header -->
        <div class="mb-8">
            <h1 class="text-2xl font-bold text-gray-900">Dashboard</h1>
            <p class="text-gray-500 text-sm mt-1">Welcome back, <strong>${sessionScope.username}</strong>. Here's your cooperative overview.</p>
        </div>

        <!-- Stat cards -->
        <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="bg-white rounded-2xl border border-gray-100 p-5">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">Total Members</span>
                    <div class="w-9 h-9 bg-green-100 rounded-xl flex items-center justify-center">
                        <svg class="w-4 h-4 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                    </div>
                </div>
                <div class="text-3xl font-extrabold text-gray-900">${stats.totalMembers != null ? stats.totalMembers : 0}</div>
                <div class="text-xs text-gray-400 mt-1">Approved members</div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">Total Savings</span>
                    <div class="w-9 h-9 bg-blue-100 rounded-xl flex items-center justify-center">
                        <svg class="w-4 h-4 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                    </div>
                </div>
                <div class="text-3xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${stats.totalSavings != null ? stats.totalSavings : 0}" pattern="#,##0"/></div>
                <div class="text-xs text-gray-400 mt-1">Total deposits held</div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">Active Loans</span>
                    <div class="w-9 h-9 bg-amber-100 rounded-xl flex items-center justify-center">
                        <svg class="w-4 h-4 text-amber-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                </div>
                <div class="text-3xl font-extrabold text-gray-900">${stats.activeLoans != null ? stats.activeLoans : 0}</div>
                <div class="text-xs text-gray-400 mt-1">Disbursed & running</div>
            </div>
            <div class="bg-white rounded-2xl border border-red-100 p-5">
                <div class="flex items-center justify-between mb-3">
                    <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">Pending Approvals</span>
                    <div class="w-9 h-9 bg-red-100 rounded-xl flex items-center justify-center">
                        <svg class="w-4 h-4 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    </div>
                </div>
                <div class="text-3xl font-extrabold text-gray-900">${stats.pendingApprovals != null ? stats.pendingApprovals : 0}</div>
                <div class="flex items-center gap-2 mt-1">
                    <div class="text-xs text-gray-400">Members awaiting</div>
                    <c:if test="${stats.pendingApprovals > 0}">
                        <a href="${pageContext.request.contextPath}/admin?page=member-approval" class="text-xs text-red-600 font-semibold hover:underline">Review →</a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Second row stats -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                </div>
                <div>
                    <div class="text-xl font-extrabold text-gray-900">Rs. <fmt:formatNumber value="${stats.totalDisbursed != null ? stats.totalDisbursed : 0}" pattern="#,##0"/></div>
                    <div class="text-xs text-gray-400">Total loans disbursed</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                </div>
                <div>
                    <div class="text-xl font-extrabold text-gray-900">${stats.defaulters != null ? stats.defaulters : 0}</div>
                    <div class="text-xs text-gray-400">Defaulted instalments</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-teal-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-teal-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                </div>
                <div>
                    <div class="text-xl font-extrabold text-gray-900">${stats.pendingLoans != null ? stats.pendingLoans : 0}</div>
                    <div class="text-xs text-gray-400">Loans pending approval</div>
                </div>
            </div>
            <div class="bg-white rounded-2xl border border-gray-100 p-5 flex items-center gap-4">
                <div class="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center flex-shrink-0">
                    <svg class="w-6 h-6 text-indigo-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2a3 3 0 00-5.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2a3 3 0 015.356-1.857m0 0a5.002 5.002 0 009.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>
                </div>
                <div>
                    <div class="text-xl font-extrabold text-gray-900">${staffCount != null ? staffCount : 0}</div>
                    <div class="text-xs text-gray-400">Registered staff accounts</div>
                </div>
            </div>
        </div>

        <!-- Quick actions -->
        <div class="bg-white rounded-2xl border border-gray-100 p-6">
            <h2 class="text-sm font-bold text-gray-700 mb-4">Quick Actions</h2>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-3">
                <a href="${pageContext.request.contextPath}/admin?page=member-approval" class="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:border-green-200 hover:bg-green-50 transition text-center">
                    <div class="w-10 h-10 bg-green-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-green-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg></div>
                    <span class="text-xs font-semibold text-gray-700">Approve Members</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin?page=loans&status=PENDING" class="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:border-amber-200 hover:bg-amber-50 transition text-center">
                    <div class="w-10 h-10 bg-amber-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-amber-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg></div>
                    <span class="text-xs font-semibold text-gray-700">Review Loans</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin?page=defaulters" class="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:border-red-200 hover:bg-red-50 transition text-center">
                    <div class="w-10 h-10 bg-red-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg></div>
                    <span class="text-xs font-semibold text-gray-700">View Defaulters</span>
                </a>
                <a href="${pageContext.request.contextPath}/report" class="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:border-purple-200 hover:bg-purple-50 transition text-center">
                    <div class="w-10 h-10 bg-purple-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-purple-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg></div>
                    <span class="text-xs font-semibold text-gray-700">Financial Reports</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin?page=staff" class="flex flex-col items-center gap-2 p-4 rounded-xl border border-gray-100 hover:border-indigo-200 hover:bg-indigo-50 transition text-center">
                    <div class="w-10 h-10 bg-indigo-100 rounded-xl flex items-center justify-center"><svg class="w-5 h-5 text-indigo-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2a3 3 0 00-5.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2a3 3 0 015.356-1.857m0 0a5.002 5.002 0 009.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg></div>
                    <span class="text-xs font-semibold text-gray-700">Manage Staff</span>
                </a>
            </div>
        </div>

    </div>
</div>
</body>
</html>