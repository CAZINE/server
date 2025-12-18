console.log('[DEBUG] script.js carregado');
document.addEventListener('DOMContentLoaded', function() {
window.addEventListener('message', function(event) {
    if (event.data.action === 'show') {
        document.getElementById('creator').style.display = 'block';
        window.isCreatorOpen = true;
    } else if (event.data.action === 'hide') {
        document.getElementById('creator').style.display = 'none';
        window.isCreatorOpen = false;
    }
});

document.getElementById('form').addEventListener('input', function(e) {
    // Sincronizar: se slider de roupa mudar, reseta textura para 0
    const pairs = [
        ['shirt', 'shirtTexture'],
        ['jacket', 'jacketTexture'],
        ['pants', 'pantsTexture'],
        ['box', 'boxTexture'],
        ['shoes', 'shoesTexture'],
        ['accessory', 'accessoryTexture'],
        ['hands', 'handsTexture'],
        ['hat', 'hatTexture'],
        ['glasses', 'glassesTexture'],
        ['mask', 'maskTexture']
    ];
    pairs.forEach(([slider, tex]) => {
        if (e && e.target && e.target.name === slider) {
            const texInput = document.querySelector(`input[name='${tex}']`);
            if (texInput) texInput.value = 0;
        }
    });

    const data = Object.fromEntries(new FormData(this).entries());
    fetch('https://character/updateAppearance', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    });
});

// Dispara update imediato ao mudar input de textura
['shirtTexture','jacketTexture','pantsTexture','boxTexture','shoesTexture','accessoryTexture','handsTexture','hatTexture','glassesTexture','maskTexture'].forEach(function(name) {
    const el = document.querySelector(`input[name='${name}']`);
    if (el) {
        el.addEventListener('input', function() {
            document.getElementById('form').dispatchEvent(new Event('input'));
        });
    }
});

const saveBtn = document.getElementById('save');
if (saveBtn) {
    saveBtn.onclick = function() {
        const data = Object.fromEntries(new FormData(document.getElementById('form')).entries());
        fetch('https://character/finishCreation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
    };
}

const exitBtn = document.getElementById('exit');
if (exitBtn) {
    exitBtn.onclick = function() {
        document.getElementById('creator').style.display = 'none';
        window.isCreatorOpen = false;
    };
}

document.addEventListener('keydown', function(e) {
    if (!window.isCreatorOpen) return;
    if (e.code === 'KeyA' || e.code === 'ArrowLeft') {
        fetch('https://character/rotate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ dir: 'left' })
        });
    } else if (e.code === 'KeyD' || e.code === 'ArrowRight') {
        fetch('https://character/rotate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ dir: 'right' })
        });
    } else if (e.code === 'KeyW' || e.code === 'ArrowUp') {
        fetch('https://character/rotate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ dir: 'up' })
        });
    } else if (e.code === 'KeyS' || e.code === 'ArrowDown') {
        fetch('https://character/rotate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ dir: 'down' })
        });
    }
});

console.log('[DEBUG] Wizard navigation inicializado');
// Wizard navigation
const steps = [
    document.getElementById('step-1'),
    document.getElementById('step-2'),
    document.getElementById('step-3')
];
let currentStep = 0;
function showStep(idx) {
    steps.forEach((el, i) => el.style.display = (i === idx ? '' : 'none'));
    console.log('[DEBUG] Mudando para etapa', idx+1);
}
const next1 = document.getElementById('next-1');
console.log('[DEBUG] next1:', next1);
if (next1) next1.onclick = () => { console.log('[DEBUG] Próximo 1'); currentStep = 1; showStep(currentStep); };
const next2 = document.getElementById('next-2');
if (next2) next2.onclick = () => { console.log('[DEBUG] Próximo 2'); currentStep = 2; showStep(currentStep); };
const back2 = document.getElementById('back-2');
if (back2) back2.onclick = () => { console.log('[DEBUG] Voltar 2'); currentStep = 0; showStep(currentStep); };
const back3 = document.getElementById('back-3');
if (back3) back3.onclick = () => { console.log('[DEBUG] Voltar 3'); currentStep = 1; showStep(currentStep); };
showStep(0);

// Sliders de tatuagem: 0 = nenhuma, 1 = tribal grande
['tattoo_arm_r','tattoo_arm_l','tattoo_leg_r','tattoo_leg_l'].forEach(function(name) {
    const el = document.querySelector(`input[name='${name}']`);
    if (el) {
        el.addEventListener('input', function() {
            document.getElementById('form').dispatchEvent(new Event('input'));
        });
    }
});
}); 