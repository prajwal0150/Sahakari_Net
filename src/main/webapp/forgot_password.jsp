<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body{font-family:'Plus Jakarta Sans',sans-serif;}</style>
</head>
<body class="min-h-screen bg-gradient-to-br from-gray-900 via-green-950 to-gray-900 flex items-center justify-center p-4">

<div class="w-full max-w-md">
    <div class="text-center mb-8">
        <a href="index.jsp" class="inline-flex items-center gap-3">
            <div class="w-12 h-12 bg-green-500 rounded-2xl flex items-center justify-center"><span class="text-gray-900 font-extrabold text-xl">S</span></div>
            <span class="text-2xl font-bold text-white">Sahakar<span class="text-green-400">iNet</span></span>
        </a>
        <p class="text-gray-400 text-sm mt-2">Reset your password using email or phone</p>
    </div>

    <div class="bg-white rounded-3xl shadow-2xl p-8">
        <h2 class="text-xl font-bold text-gray-900 mb-6">Forgot Password</h2>
        <div class="bg-amber-50 border border-amber-200 text-amber-800 rounded-xl px-4 py-3 text-sm">
            <%= request.getAttribute("notice") != null ? request.getAttribute("notice") : "Not available for reset password." %>
        </div>

        <div class="mt-6 pt-6 border-t border-gray-100 text-center">
            <a href="login" class="text-sm text-green-700 font-semibold hover:underline">Back to Login</a>
        </div>
    </div>
</div>

</body>
</html>
