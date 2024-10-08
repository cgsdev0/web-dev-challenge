
source config.sh

htmx_page << HTML
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

.container {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.newtons-cradle {
    --uib-size: 250px;
    --uib-speed: 1.2s;
    --uib-color: #d1d5db;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: var(--uib-size);
    height: var(--uib-size);
}

.newtons-cradle__dot {
    position: relative;
    display: flex;
    align-items: center;
    height: 100%;
    width: 25%;
    transform-origin: center top;
}

.newtons-cradle__dot::after {
    content: '';
    display: block;
    width: 100%;
    height: 25%;
    border-radius: 50%;
    background-color: var(--uib-color);
}

.newtons-cradle__dot:first-child {
    animation: swing var(--uib-speed) linear infinite;
}

.newtons-cradle__dot:last-child {
    animation: swing2 var(--uib-speed) linear infinite;
}

@keyframes swing {
    0% {
        transform: rotate(0deg);
        animation-timing-function: ease-out;
    }
    25% {
        transform: rotate(70deg);
        animation-timing-function: ease-in;
    }
    50% {
        transform: rotate(0deg);
        animation-timing-function: linear;
    }
}

@keyframes swing2 {
    0% {
        transform: rotate(0deg);
        animation-timing-function: linear;
    }
    50% {
        transform: rotate(0deg);
        animation-timing-function: ease-out;
    }
    75% {
        transform: rotate(-70deg);
        animation-timing-function: ease-in;
    }
}

@media screen and (max-width: 500px) {
    .newtons-cradle {
        --uib-size: 150px;
    }
}

</style>
<ul class="circles">
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
      </ul>
<div class="h-screen flex items-center justify-center">
  <div id="entire-form" class="bg-gradient-to-b p-10 from-gray-400/30 to-gray-200/30 rounded-xl shadow-lg w-[30rem] backdrop-blur-lg">
  <div class="absolute inset-0 rounded-xl pointer-events-none blur-md shadow-xl shadow-white/60"></div>
    <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center text-shadow-md">
      <span class="bg-clip-text text-transparent bg-gradient-to-r from-blue-500 to-green-500">
      Thank You Card Generator
      </span>
    </h1>

    <form method="POST" action="/generate" class="space-y-6">
      <div>
        <label for="sender_name" class="block text-sm font-medium text-gray-700">Your Name</label>
        <input type="text" id="sender_name" placeholder="You" name="sender_name" class="mt-1 block w-full p-2 rounded-md border-gray-300 bg-gray-200 focus:border-blue-500 focus:ring-blue-500 shadow-sm sm:text-sm" required>
      </div>

      <div>
        <label for="recipient_name" class="block text-sm font-medium text-gray-700">Recipient Name</label>
        <input type="text" placeholder="Someone" id="recipient_name" name="recipient_name" class="mt-1 block w-full p-2 rounded-md border-gray-300 bg-gray-200 focus:border-blue-500 focus:ring-blue-500 shadow-sm sm:text-sm" required>
      </div>

      <div>
        <label for="reason" class="block text-sm font-medium text-gray-700">Reason for Thanks</label>
        <textarea placeholder="What are you grateful for?" id="reason" name="reason" rows="4" class="mt-1 block w-full p-2 rounded-md border-gray-300 bg-gray-200 focus:border-blue-500 focus:ring-blue-500 shadow-sm sm:text-sm resize-y" required></textarea>
      </div>


      <button class="w-full bg-gradient-to-r from-blue-500 to-green-500 hover:from-blue-600 hover:to-green-600 text-white font-bold py-3 px-6 rounded-lg shadow-lg transition duration-200 ease-in-out transform hover:scale-105" hx-post="/generate" hx-swap="outerHTML" _="on click remove #entire-form" hx-indicator="#spinner">
        Generate Card!
      </button>
    </form>
  </div>
  <div class="htmx-indicator absolute pointer-events-none flex flex-col items-center gap" id="spinner">
  <p class="text-3xl font-bold text-gray-300">Generating Your Card...</p>
          <div class="newtons-cradle">
            <div class="newtons-cradle__dot"></div>
            <div class="newtons-cradle__dot"></div>
            <div class="newtons-cradle__dot"></div>
            <div class="newtons-cradle__dot"></div>
        </div>
    </div>
</div>
HTML
