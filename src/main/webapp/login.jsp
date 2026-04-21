<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — SahakariNet</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #F1F5F9;
        }
    </style>
</head>

<body class="min-h-screen flex items-center justify-center px-4">

<div class="w-full max-w-6xl bg-white rounded-[32px] shadow-[0_25px_60px_rgba(0,0,0,0.08)] overflow-hidden flex flex-col md:flex-row">

    <!-- LEFT SIDE -->
    <div class="w-full md:w-2/5 bg-[#EEF4FF] p-12 flex flex-col justify-between">

        <!-- Logo + Text -->
        <div>
            <div class="flex items-center gap-3 mb-6">
                <div class="w-11 h-11 bg-blue-600 rounded-xl flex items-center justify-center text-white font-bold text-lg">S</div>
                <h1 class="text-2xl font-extrabold text-gray-900">
                    Sahakari<span class="text-blue-600">Net</span>
                </h1>
            </div>

            <p class="text-gray-600 text-sm leading-relaxed">
                A secure academic project interface for managing members, savings, loans, reports, and cooperative operations with clarity.
            </p>
        </div>

        <!-- Stats Card -->
        <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 mt-10">
            <p class="text-[10px] font-semibold text-gray-400 uppercase tracking-widest mb-2">
                Built for Nepal's cooperative sector
            </p>
            <h2 class="text-4xl font-extrabold text-gray-900 mb-2">34,000+</h2>
            <p class="text-sm text-gray-500">
                Community cooperatives can move from paper-based records to a cleaner and more transparent digital workflow.
            </p>
        </div>

        <!-- Features -->
        <div class="mt-10 space-y-4 text-sm text-gray-600">
            <div class="flex items-start gap-3">
                <div class="w-8 h-8 bg-blue-100 text-blue-600 flex items-center justify-center rounded-lg">✓</div>
                <p>Role-based access for admin, staff, and members</p>
            </div>
            <div class="flex items-start gap-3">
                <div class="w-8 h-8 bg-blue-100 text-blue-600 flex items-center justify-center rounded-lg">✓</div>
                <p>Reliable savings, loan, and repayment management</p>
            </div>
            <div class="flex items-start gap-3">
                <div class="w-8 h-8 bg-blue-100 text-blue-600 flex items-center justify-center rounded-lg">✓</div>
                <p>Clear reports for operations, auditing, and trust</p>
            </div>
        </div>
    </div>

    <!-- RIGHT SIDE -->
    <div class="w-full md:w-3/5 p-10 md:p-16 flex flex-col justify-center">

        <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="bg-green-50 border border-green-200 text-green-700 text-sm px-4 py-3 rounded-xl mb-6 flex items-center gap-2">
            ✓ You have been logged out successfully.
        </div>
        <% } %>

        <h2 class="text-3xl font-extrabold text-gray-900 mb-2">Welcome back</h2>
        <p class="text-gray-500 text-sm mb-8">
            Sign in to continue to your cooperative dashboard.
        </p>

        <form action="login" method="post" class="space-y-5">

            <div>
                <label class="block text-xs font-semibold text-gray-600 uppercase mb-2">Username</label>
                <input type="text" name="username" placeholder="Enter your username" required
                       class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
            </div>

            <div>
                <label class="block text-xs font-semibold text-gray-600 uppercase mb-2">Password</label>
                <input type="password" name="password" placeholder="Enter your password" required
                       class="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm focus:ring-2 focus:ring-blue-500 outline-none">

                <div class="text-right mt-2">
                    <a href="forgot-password" class="text-xs text-blue-600 font-semibold hover:underline">
                        Forgot password?
                    </a>
                </div>
            </div>

            <button type="submit"
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3.5 rounded-xl text-sm transition">
                Sign In →
            </button>
        </form>

        <p class="text-center text-sm text-gray-500 mt-6">
            Don't have an account?
            <a href="register.jsp" class="text-blue-600 font-semibold hover:underline">
                Register here
            </a>
        </p>

        <div class="text-center mt-8">
            <a href="index.jsp" class="text-xs text-gray-400 hover:text-gray-600 underline">
                ← Back to home
            </a>
        </div>

    </div>
</div>

</body>
</html>