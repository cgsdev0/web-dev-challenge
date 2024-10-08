if [[ ! -f data/cards/${PATH_VARS[id]}/front ]]; then
  return $(status_code 404)
fi
FRONT="$(< data/cards/${PATH_VARS[id]}/front)"
INSIDE="$(< data/cards/${PATH_VARS[id]}/inside)"
FROM="$(< data/cards/${PATH_VARS[id]}/from)"
BG_COLOR="$(< data/cards/${PATH_VARS[id]}/bg_color)"

htmx_page <<HTML

<style>
@keyframes open-front-back {
  100% {
    rotate: y 0deg;
  }
  0% {
    rotate: y 180deg;
  }
}
@keyframes open-front {
  0% {
    rotate: y 0deg;
  }
  100% {
    rotate: y 180deg;
  }
}
@keyframes open-whole {
  0% {
    translate: -15rem -2rem;
    rotate: z 10deg;
  }
  100% {
    translate: 0 0;
    rotate: z 0deg;
  }
}

.card-front {
  background-color: ${BG_COLOR};
  transform-origin: top left;
  transform-style: preserve-3d;
  perspective: 1000px;
  backface-visibility: hidden;
  translate: 30rem;
}

.card-whole {
  translate: -15rem -2rem;
  rotate: z 10deg;
}

.card-whole {
  cursor: pointer;
}
.card-whole.opened {
  animation: open-whole 3s forwards;
  cursor: initial;
}
.opened {
  .card-front {
    animation: open-front 3s forwards;
  }
  .card-front-back {
    animation: open-front-back 3s forwards;
  }
}
.card-front-back {
  rotate: y 180deg;
  transform-origin: top right;
  transform-style: preserve-3d;
  perspective: 1000px;
  backface-visibility: hidden;
}
.card-back {
z-index: -2;
}
.sig {
  transform-style: preserve-3d;
font-size: 32pt;
transform: rotate(-4deg);
translate: 20px;
  z-index: -1;
  font-family: "Cedarville Cursive", cursive;
  font-weight: 400;
  font-style: normal;
}
</style>
<div class="h-screen flex items-center justify-center">
    <div class="relative card-whole flex grow-0 h-[45rem]" _="on click add .opened">
      <div class="p-10 card-front flex-col justify-evenly flex h-[45rem] w-[30rem]">
       <p class="text-3xl font-bold text-center">${FRONT}</p>
       <img src="img.png" />
      </div>
      <div class="p-10 absolute card-front-back bg-white border-r-2 border-gray-200 h-[45rem] w-[30rem] rounded-l-md">
      </div>
      <div class="flex flex-col gap-10 justify-center p-10 card-back bg-white h-[45rem] w-[30rem] rounded-r-md">
        <p>${INSIDE}</p>
        <p class="sig">${FROM}</p>
      </div>
    </div>
  </div>
HTML
