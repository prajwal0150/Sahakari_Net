<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - SahakariNet</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-gradient-to-br from-sky-50 via-white to-emerald-50 min-h-screen text-gray-800">
<% String ctx = request.getContextPath(); %>

<nav class="bg-white/90 backdrop-blur border-b border-gray-100 sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <a href="<%= ctx %>/index.jsp" class="flex items-center gap-3">
            <div class="w-9 h-9 bg-green-700 rounded-xl flex items-center justify-center"><span class="text-white font-bold">S</span></div>
            <span class="text-xl font-bold text-gray-900">Sahakar<span class="text-green-700">iNet</span></span>
        </a>
        <div class="flex items-center gap-5 text-sm font-medium">
            <a href="<%= ctx %>/about.jsp" class="text-gray-600 hover:text-green-700">About</a>
            <a href="<%= ctx %>/contact.jsp" class="text-green-700">Contact</a>
            <a href="<%= ctx %>/login.jsp" class="text-gray-600 hover:text-green-700">Login</a>
        </div>
    </div>
</nav>

<section class="text-center py-16 px-6">
    <h2 class="text-4xl md:text-5xl font-extrabold text-gray-900 mb-3 tracking-tight">Contact Us</h2>
    <p class="text-gray-600 text-lg">Have questions or feedback? We are here to help you.</p>
</section>

<section class="max-w-6xl mx-auto px-6 pb-16">
    <% if ("true".equals(request.getParameter("sent"))) { %>
    <div class="mb-6 bg-green-50 border border-green-200 text-green-800 rounded-2xl px-5 py-4 text-sm">
        Your message has been sent successfully. Thank you for contacting SahakariNet.
    </div>
    <% } %>

    <% if ("missing".equals(request.getParameter("error"))) { %>
    <div class="mb-6 bg-red-50 border border-red-200 text-red-800 rounded-2xl px-5 py-4 text-sm">
        Please fill in all required fields before submitting.
    </div>
    <% } %>

    <% if ("failed".equals(request.getParameter("error"))) { %>
    <div class="mb-6 bg-red-50 border border-red-200 text-red-800 rounded-2xl px-5 py-4 text-sm">
        Sorry, we could not send your message right now. Please try again later.
    </div>
    <% } %>

    <div class="grid md:grid-cols-2 gap-10">
        <div class="backdrop-blur bg-white/80 border border-white/50 p-8 rounded-3xl shadow-lg">
            <h3 class="text-2xl font-semibold mb-6 text-gray-900">Get in Touch</h3>
            <div class="space-y-5 text-gray-700">
                <div class="flex items-center gap-3">
                    <span class="text-sky-600 text-xl">📍</span>
                    <p>Dharan, Nepal</p>
                </div>
                <div class="flex items-center gap-3">
                    <span class="text-sky-600 text-xl">📞</span>
                    <p>+977-98XXXXXXXX</p>
                </div>
                <div class="flex items-center gap-3">
                    <span class="text-sky-600 text-xl">📧</span>
                    <p>info@sahakarinet.com</p>
                </div>
            </div>
            <div class="mt-10">
                <h4 class="font-semibold text-gray-800 mb-2">Office Hours</h4>
                <p class="text-gray-600">Sunday - Friday: 9 AM - 5 PM</p>
            </div>
        </div>

        <div class="backdrop-blur bg-white/80 border border-white/50 p-8 rounded-3xl shadow-lg">
            <h3 class="text-2xl font-semibold mb-6 text-gray-900">Send Message</h3>

            <form action="<%= ctx %>/contact" method="post" class="space-y-5">
                <div>
                    <label class="block text-gray-700 mb-1">Full Name</label>
                    <input type="text" name="name" required
                           class="w-full px-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-sky-500 outline-none transition">
                </div>

                <div>
                    <label class="block text-gray-700 mb-1">Email</label>
                    <input type="email" name="email" required
                           class="w-full px-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-sky-500 outline-none transition">
                </div>

                <div>
                    <label class="block text-gray-700 mb-1">Subject</label>
                    <input type="text" name="subject"
                           class="w-full px-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-sky-500 outline-none transition">
                </div>

                <div>
                    <label class="block text-gray-700 mb-1">Message</label>
                    <textarea name="message" rows="4" required
                              class="w-full px-4 py-2 bg-white border border-gray-200 rounded-xl focus:ring-2 focus:ring-sky-500 outline-none transition"></textarea>
                </div>

                <button type="submit"
                        class="w-full bg-gradient-to-r from-sky-600 to-emerald-600 text-white py-2.5 rounded-xl font-semibold hover:shadow-lg transition">
                    Send Message
                </button>
            </form>
        </div>
    </div>
</section>

<footer class="py-8 text-center text-xs text-gray-500 border-t border-gray-100 bg-white/60">
    SahakariNet • Contact and Support
</footer>
</body>
</html>
