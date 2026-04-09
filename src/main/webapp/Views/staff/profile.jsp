<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>My Profile - SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-2xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">My Profile</h1>

        <c:if test="${param.msg == 'password-updated'}">
            <div class="bg-green-50 border border-green-200 text-green-800 rounded-2xl px-4 py-3 mb-5 text-sm">Password updated successfully.</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="bg-red-50 border border-red-200 text-red-800 rounded-2xl px-4 py-3 mb-5 text-sm">
                <c:choose>
                    <c:when test="${param.error == 'missingFields'}">All password fields are required.</c:when>
                    <c:when test="${param.error == 'passwordMismatch'}">New password and confirmation do not match.</c:when>
                    <c:when test="${param.error == 'invalidPassword'}">New password must be at least 6 characters.</c:when>
                    <c:when test="${param.error == 'currentPasswordInvalid'}">Current password is incorrect.</c:when>
                    <c:otherwise>Unable to update password. Please try again.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${staff != null}">
                <div class="bg-white rounded-2xl border border-gray-100 p-7">
                    <div class="flex items-center gap-5 mb-7 pb-6 border-b border-gray-100">
                        <div class="w-20 h-20 rounded-2xl bg-blue-100 flex items-center justify-center text-blue-700 font-extrabold text-4xl uppercase">
                            ${empty staff.fullName ? staff.username.substring(0,1) : staff.fullName.substring(0,1)}
                        </div>
                        <div>
                            <h2 class="text-xl font-bold text-gray-900">${empty staff.fullName ? '-' : staff.fullName}</h2>
                            <p class="text-sm text-gray-500">@${staff.username}</p>
                            <span class="inline-block mt-2 bg-blue-100 text-blue-700 text-xs font-bold px-3 py-1 rounded-full">STAFF</span>
                        </div>
                    </div>

                    <div class="space-y-4">
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Full Name</span>
                            <span class="text-sm font-semibold text-gray-900">${empty staff.fullName ? '-' : staff.fullName}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Username</span>
                            <span class="text-sm font-semibold text-gray-900">${staff.username}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Email</span>
                            <span class="text-sm font-semibold text-gray-900">${empty staff.email ? '-' : staff.email}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Phone</span>
                            <span class="text-sm font-semibold text-gray-900">${empty staff.phone ? '-' : staff.phone}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Permanent Address</span>
                            <span class="text-sm font-semibold text-gray-900">${empty staff.permanentAddress ? '-' : staff.permanentAddress}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-gray-50">
                            <span class="text-sm text-gray-400">Temporary Address</span>
                            <span class="text-sm font-semibold text-gray-900">${empty staff.temporaryAddress ? '-' : staff.temporaryAddress}</span>
                        </div>
                        <div class="flex justify-between py-2">
                            <span class="text-sm text-gray-400">Joined Date</span>
                            <span class="text-sm font-semibold text-gray-900">
                                <fmt:formatDate value="${staff.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </span>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white rounded-2xl border border-gray-100 p-6 text-sm text-gray-600">
                    Staff profile details are not available yet. Please contact admin.
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${staff != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-7 mt-6">
                <h2 class="text-lg font-bold text-gray-900 mb-4">Update Password</h2>
                <form action="${pageContext.request.contextPath}/staff" method="post" class="space-y-4">
                    <input type="hidden" name="action" value="update-password">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">Current Password</label>
                        <input type="password" name="currentPassword" required
                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-gray-50">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">New Password</label>
                        <input type="password" name="newPassword" required minlength="6"
                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-gray-50">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1.5">Confirm New Password</label>
                        <input type="password" name="confirmPassword" required
                               class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 bg-gray-50">
                    </div>
                    <button type="submit" class="inline-flex items-center justify-center bg-blue-700 hover:bg-blue-800 text-white font-semibold py-3 px-5 rounded-xl text-sm transition">
                        Save Password
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</div>
</body>
</html>
