<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- ═══════════════════════════════════════════════════
     FILE: /views/_nav.jsp
     USAGE: <%@ include file="/views/_nav.jsp" %>
     Renders the correct sidebar based on session role.
═══════════════════════════════════════════════════ --%>
<c:set var="ctx"  value="${pageContext.request.contextPath}"/>
<c:set var="role" value="${sessionScope.role}"/>
<c:set var="uname" value="${sessionScope.username}"/>

<!-- Sidebar -->
<aside id="sidebar" class="fixed top-0 left-0 h-full w-64 bg-gray-50 text-gray-900 z-40 flex flex-col border-r border-gray-200 shadow-sm transition-transform duration-300 lg:translate-x-0 -translate-x-full">
    <!-- Logo -->
    <div class="flex items-center gap-3 px-5 py-4 border-b border-gray-200">
        <div class="w-9 h-9 bg-blue-600 rounded-lg flex items-center justify-center font-bold text-white text-lg">S</div>
        <div>
            <div class="font-semibold text-gray-900 text-sm leading-tight">SahakariNet</div>
            <div class="text-xs text-gray-500 capitalize">${role != null ? role.toLowerCase() : ''} panel</div>
        </div>
    </div>

    <!-- Nav links -->
    <nav class="flex-1 overflow-y-auto px-3 py-4 space-y-1">
        <c:choose>
            <c:when test="${role == 'ADMIN'}">
                <a href="${ctx}/admin"                        class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>Dashboard</a>
                <a href="${ctx}/admin?page=member-approval"   class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>Approvals</a>
                <a href="${ctx}/admin?page=members"           class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>Members</a>
                <a href="${ctx}/admin?page=loans"             class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>Loans</a>
                <a href="${ctx}/admin?page=defaulters"        class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>Defaulters</a>
                <a href="${ctx}/admin?page=transactions"      class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>Transactions</a>
                <a href="${ctx}/admin?page=staff"             class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2a3 3 0 00-5.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2a3 3 0 015.356-1.857m0 0a5.002 5.002 0 009.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>Staff</a>
                <a href="${ctx}/admin?page=reports"           class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>Reports</a>
            </c:when>
            <c:when test="${role == 'STAFF'}">
                <a href="${ctx}/staff"                    class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>Dashboard</a>
                <a href="${ctx}/staff?page=search"        class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>Search Member</a>
                <a href="${ctx}/staff?page=deposit"       class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>Deposit</a>
                <a href="${ctx}/staff?page=withdrawal"    class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>Withdrawal</a>
                <a href="${ctx}/staff?page=loan-disburse" class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"/></svg>Disburse Loan</a>
                <a href="${ctx}/staff?page=repayment"     class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>Repayment</a>
                <a href="${ctx}/staff?page=profile"       class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>My Profile</a>
            </c:when>
            <c:when test="${role == 'MEMBER'}">
                <a href="${ctx}/member"                            class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>Dashboard</a>
                <a href="${ctx}/member?page=savings"               class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>My Savings</a>
                <a href="${ctx}/member?page=transactions"          class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>Transactions</a>
                <a href="${ctx}/member?page=apply-loan"            class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>Apply for Loan</a>
                <a href="${ctx}/member?page=my-loans"              class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>My Loans</a>
                <a href="${ctx}/member?page=profile"               class="nav-link"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>My Profile</a>
            </c:when>
        </c:choose>
    </nav>

    <!-- User + logout -->
    <div class="px-4 py-4 border-t border-gray-200 bg-white/70">
        <div class="flex items-center gap-3 mb-3">
            <div class="w-8 h-8 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center font-bold text-xs uppercase">
                ${uname != null ? uname.substring(0,1) : 'U'}
            </div>
            <div>
                <div class="text-xs font-medium text-gray-800">${uname}</div>
                <div class="text-xs text-gray-500">${role}</div>
            </div>
        </div>
        <a href="${ctx}/logout" class="flex items-center gap-2 text-xs text-gray-500 hover:text-red-500 transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
            Logout
        </a>
    </div>
</aside>

<!-- Mobile overlay -->
<div id="sidebar-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-30 hidden lg:hidden" onclick="toggleSidebar()"></div>

<!-- Mobile toggle button -->
<button onclick="toggleSidebar()" class="fixed top-4 left-4 z-50 lg:hidden bg-white border border-gray-200 text-gray-700 p-2 rounded-lg shadow-sm">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
</button>

<style>
    .nav-link {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 500;
        color: #374151;
        text-decoration: none;
        transition: all 0.15s ease;
    }
    .nav-link:hover {
        background: #f3f4f6;
        color: #111827;
    }
    .nav-link.active {
        background: #dbeafe;
        color: #2563eb;
        font-weight: 600;
    }
    .nav-link svg {
        flex-shrink: 0;
        opacity: 0.9;
    }
</style>
<script>
    function toggleSidebar() {
        const sb = document.getElementById('sidebar');
        const ov = document.getElementById('sidebar-overlay');
        sb.classList.toggle('-translate-x-full');
        ov.classList.toggle('hidden');
    }

    // Mark active link using exact path + page query matching.
    // This prevents /staff?page=deposit from also activating /staff (Dashboard).
    (function markActiveNavLink() {
        const currentUrl = new URL(window.location.href);
        const currentPath = currentUrl.pathname;
        const currentPage = currentUrl.searchParams.get('page');

        document.querySelectorAll('.nav-link').forEach((link) => {
            const href = link.getAttribute('href');
            if (!href)
                return;

            const linkUrl = new URL(href, window.location.origin);
            if (linkUrl.pathname !== currentPath)
                return;

            const linkPage = linkUrl.searchParams.get('page');

            if (linkPage) {
                if (linkPage === currentPage) {
                    link.classList.add('active');
                }
            } else if (!currentPage) {
                link.classList.add('active');
            }
        });
    })();
</script>
