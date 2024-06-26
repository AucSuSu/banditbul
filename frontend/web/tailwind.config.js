/** @type {import('tailwindcss').Config} */
export default {
    content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
    theme: {
        extend: {
            fontFamily: {
                jamsil: ["TheJamsil5Bold", "sans-serif"],
                jamsilLight: ["TheJamsil3Regular"],
                jamsilMedium: ["TheJamsil4Medium"],
                prentendard: ["Pretendard-Regular"],
                pretendardSemi: ["Pretendard-semi"],
                PyeongChangPeaceBold: ["PyeongChangPeace"],
            },
        },
    },
    plugins: [
        function ({ addUtilities }) {
            const newUtilities = {
                ".flex-c": {
                    display: "flex",
                    "justify-content": "center",
                    "align-items": "center",
                },
                ".flex-cc": {
                    display: "flex",
                    "flex-direction": "column",
                    "justify-content": "center",
                    "align-items": "center",
                },
                ".border-basic": {
                    borderWidth: "2px",
                    borderColor: "#565656",
                    borderRadius: "1.5rem",
                    backgroundColor: "#ffffff",
                    boxShadow:
                        "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)",
                },
            };
            addUtilities(newUtilities);
        },
    ],
};
