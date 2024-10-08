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
    rotate: z 7deg;
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

.outline-me {
text-shadow: rgb(0, 0, 0) 2px 0px 0px, rgb(0, 0, 0) 1.75517px 0.958851px 0px, rgb(0, 0, 0) 1.0806px 1.68294px 0px, rgb(0, 0, 0) 0.141474px 1.99499px 0px, rgb(0, 0, 0) -0.832294px 1.81859px 0px, rgb(0, 0, 0) -1.60229px 1.19694px 0px, rgb(0, 0, 0) -1.97998px 0.28224px 0px, rgb(0, 0, 0) -1.87291px -0.701566px 0px, rgb(0, 0, 0) -1.30729px -1.5136px 0px, rgb(0, 0, 0) -0.421592px -1.95506px 0px, rgb(0, 0, 0) 0.567324px -1.91785px 0px, rgb(0, 0, 0) 1.41734px -1.41108px 0px, rgb(0, 0, 0) 1.92034px -0.558831px 0px;
}

.card-whole {
  translate: -15rem -2rem;
  rotate: z 10deg;
}

.card-whole {
  cursor: pointer;
  transition: rotate 0.5s;
}

.card-whole:hover {
  cursor: pointer;
  rotate: z 7deg;
}

.card-whole.opened {
  transition: initial;
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
<div class="relative drop-shadow-2xl card-whole flex grow-0 h-[45rem]" _="on click add .opened then js onPop()">
      <div class="p-10 card-front flex-col justify-evenly flex h-[45rem] w-[30rem]">
       <p class="text-3xl font-bold text-center text-white outline-me">${FRONT}</p>
       <img src="img.png" class="rounded-xl" />
      </div>
      <div class="p-10 absolute card-front-back bg-white border-r-2 border-gray-200 h-[45rem] w-[30rem] rounded-l-md flex items-center justify-center flex-col">
      <p class="text-gray-300">Like this card?</p>
      <a class="text-blue-300 hover:underline" href="/">Create your own!</a>
      </div>
      <div class="flex flex-col gap-10 justify-center p-10 card-back bg-white h-[45rem] w-[30rem] rounded-r-md">
        <p>${INSIDE}</p>
        <p class="sig">${FROM}</p>
      </div>
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/@tsparticles/confetti@3.0.3/tsparticles.confetti.bundle.min.js"></script>
  <script>
  var onPop = () => {
  const count = 200,
  defaults = {
    origin: { y: 1.0 },
  };

function fire(particleRatio, opts) {
  confetti(
    Object.assign({}, defaults, opts, {
      particleCount: Math.floor(count * particleRatio),
    })
  );
}

fire(0.25, {
  spread: 26,
  startVelocity: 55,
});

fire(0.2, {
  spread: 60,
});

fire(0.35, {
  spread: 100,
  decay: 0.91,
  scalar: 0.8,
});

fire(0.1, {
  spread: 120,
  startVelocity: 25,
  decay: 0.92,
  scalar: 1.2,
});

fire(0.1, {
  spread: 120,
  startVelocity: 45,
});
};
</script>
HTML
