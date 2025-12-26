// Safari-compatible WASM initializer
// This matches trunk's expected initializer interface

export default function initializer() {
    return {
        onStart: () => {
            console.log('WASM loading started...');
        },
        onProgress: ({ current, total }) => {
            if (total > 0) {
                const pct = Math.round((current / total) * 100);
                console.log(`WASM loading: ${pct}%`);
            }
        },
        onComplete: () => {
            console.log('WASM loading complete');
        },
        onSuccess: (wasm) => {
            console.log('WASM initialized successfully');
        },
        onFailure: (error) => {
            console.error('WASM initialization failed:', error);
            document.body.innerHTML = `
                <div style="padding:40px; color:#ff4444; font-family:monospace; background:#0a0a0f; min-height:100vh;">
                    <h1>WASM Load Error</h1>
                    <p>Failed to initialize WebAssembly module.</p>
                    <p style="color:#888; margin-top:10px;">${error}</p>
                    <p style="margin-top:20px; color:#00ff88;">Please try:</p>
                    <ul style="margin-left:20px; margin-top:10px;">
                        <li>Using a modern browser (Chrome, Firefox, Edge)</li>
                        <li>Refreshing the page</li>
                    </ul>
                </div>
            `;
        }
    };
}
