"use client";

import { useEffect, useState } from "react";

export default function Gallery() {
    const [years, setYears] = useState([]);
    const [months, setMonths] = useState([]);
    const [gallery, setGallery] = useState([]);
    const [year, setYear] = useState("");
    const [month, setMonth] = useState("");

    useEffect(() => {
        // Fetch available years from Firebase
        fetch("https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com/gallery.json")
            .then((res) => res.json())
            .then((data) => setYears(Object.keys(data || {})));
    }, []);

    const handleYearChange = (selectedYear) => {
        setYear(selectedYear);
        setMonth("");
        setGallery([]); // Clear previous images

        // Fetch months available for the selected year
        fetch(`https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com/gallery/${selectedYear}.json`)
            .then((res) => res.json())
            .then((data) => setMonths(Object.keys(data || {})));
    };

    const handleMonthChange = (selectedMonth) => {
        setMonth(selectedMonth);
        setGallery([]);

        // Fetch images for the selected year and month
        fetch(`https://unit-bimbingan-dan-kaunseling-default-rtdb.firebaseio.com/gallery/${year}/${selectedMonth}.json`)
            .then((res) => res.json())
            .then((data) => setGallery(Object.values(data || {})));
    };

    return (
        <div className="container">
            <h1>📸 Telegram Gallery</h1>

            {/* Select Year */}
            <select className="select-button" onChange={(e) => handleYearChange(e.target.value)}>
                <option value="">Select Year</option>
                {years.map((y) => (
                    <option key={y} value={y}>{y}</option>
                ))}
            </select>

            {/* Select Month */}
            {year && (
                <select className="select-button" onChange={(e) => handleMonthChange(e.target.value)}>
                    <option value="">Select Month</option>
                    {months.map((m) => (
                        <option key={m} value={m}>{m}</option>
                    ))}
                </select>
            )}

            {/* Display Images */}
            {year && month && (
                <div className="gallery">
                    {gallery.length > 0 ? (
                        gallery.map((img, index) => (
                            <div className="card" key={index}>
                                {img.media_type === "photo" ? (
                                    <img 
                                        src={`https://api.telegram.org/file/bot7399332532:AAGerDfEQKKssXI0cN_naYdL0EA-57Mp1OA/${img.file_id}`} 
                                        alt={img.caption || "No Caption"} 
                                    />
                                ) : (
                                    <p>📄 Document: {img.title}</p>
                                )}
                                <p><strong>{img.date}</strong></p>
                                <p>{img.title}</p>
                                <p>{img.caption}</p>
                            </div>
                        ))
                    ) : (
                        <p>No images found for this selection.</p>
                    )}
                </div>
            )}

            <style jsx>{`
                .container { 
                    text-align: center; 
                    padding: 20px; 
                    background-color: #f0f0f0;
                    min-height: 100vh;
                }
                .select-button { 
                    margin: 10px; 
                    padding: 10px 15px; 
                    font-size: 16px;
                    background-color: #4a90e2; 
                    color: white; 
                    border: none;
                    border-radius: 5px;
                    cursor: pointer;
                    transition: background-color 0.3s ease;
                }
                .select-button:hover {
                    background-color: #357abd;
                }
                .gallery { 
                    display: flex; 
                    flex-wrap: wrap; 
                    justify-content: center; 
                    margin-top: 20px;
                }
                .card { 
                    border: 1px solid #ddd; 
                    padding: 15px; 
                    margin: 10px; 
                    width: 220px; 
                    text-align: center; 
                    background-color: white;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                img { 
                    max-width: 100%; 
                    border-radius: 5px; 
                }
                h1 {
                    color: #333;
                    margin-bottom: 20px;
                }
            `}</style>
        </div>
    );
}
