<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- FILE: src/main/webapp/views/member/profile.jsp --%>
<!DOCTYPE html><html lang="en"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>My Profile — SahakariNet</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head><body class="bg-gray-50">
<jsp:include page="/_nav.jsp"/>
<div class="lg:ml-64 min-h-screen">
    <div class="max-w-2xl mx-auto px-6 py-8">
        <h1 class="text-2xl font-bold text-gray-900 mb-6">My Profile</h1>
        <c:if test="${member != null}">
            <div class="bg-white rounded-2xl border border-gray-100 p-7">
                <!-- Avatar -->
                <div class="flex items-center gap-5 mb-7 pb-6 border-b border-gray-100">
                    <div class="w-20 h-20 rounded-2xl bg-green-100 flex items-center justify-center text-green-700 font-extrabold text-4xl uppercase">${member.fullName.substring(0,1)}</div>
                    <div>
                        <h2 class="text-xl font-bold text-gray-900">${member.fullName}</h2>
                        <p class="text-sm text-gray-500">@${member.username}</p>
                        <span class="inline-block mt-2 bg-green-100 text-green-700 text-xs font-bold px-3 py-1 rounded-full">MEMBER</span>
                    </div>
                </div>
                <!-- Details -->
                <div class="space-y-4">
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Full Name</span>
                        <span class="text-sm font-semibold text-gray-900">${member.fullName}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Username</span>
                        <span class="text-sm font-semibold text-gray-900">${member.username}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Phone</span>
                        <span class="text-sm font-semibold text-gray-900">${member.phone}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Address</span>
                        <span class="text-sm font-semibold text-gray-900">${member.address}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Citizenship No.</span>
                        <span class="text-sm font-mono font-semibold text-gray-900">${member.citizenshipNo}</span>
                    </div>
                    <div class="flex justify-between py-2 border-b border-gray-50">
                        <span class="text-sm text-gray-400">Date of Birth</span>
                        <span class="text-sm font-semibold text-gray-900">${member.dateOfBirth}</span>
                    </div>
                    <div class="flex justify-between py-2">
                        <span class="text-sm text-gray-400">Member Since</span>
                        <span class="text-sm font-semibold text-gray-900">${member.joinedDate}</span>
                    </div>
                </div>
                <c:if test="${savings != null}">
                    <div class="mt-6 pt-5 border-t border-gray-100">
                        <div class="flex justify-between items-center">
                            <span class="text-sm text-gray-400">Savings Balance</span>
                            <span class="text-xl font-extrabold text-green-700">Rs. <fmt:formatNumber value="${savings.balance}" pattern="#,##0.00"/></span>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:if>
    </div></div>
</body></html>
