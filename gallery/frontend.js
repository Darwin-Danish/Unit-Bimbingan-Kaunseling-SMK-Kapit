import { useEffect, useState } from "react";

export default function Gallery() {
    const [gallery, setGallery] = useState({});
    const [selectedYear, setSelectedYear] = useState(null);
    const [selectedMonth, setSelectedMonth] = useState(null);

    useEffect(() => {
        fetch("http://localhost:8000/gallery")  // Calls FastAPI API
            .then((res) => res.json())
            .then((data) => setGallery(data));
    }, []);

    return (
        <div>
            <h1 className="text-2xl font-bold">Gallery</h1>

            {/* Select Year */}
            <select onChange={(e) => setSelectedYear(e.target.value)}>
                <option value="">Select Year</option>
                {Object.keys(gallery).map((year) => (
                    <option key={year} value={year}>{year}</option>
                ))}
            </select>

            {/* Select Month (Only show months that exist) */}
            {selectedYear && (
                <select onChange={(e) => setSelectedMonth(e.target.value)}>
                    <option value="">Select Month</option>
                    {Object.keys(gallery[selectedYear]).map((month) => (
                        <option key={month} value={month}>{month}</option>
                    ))}
                </select>
            )}

            {/* Display Images */}
            {selectedYear && selectedMonth && (
                <div className="grid grid-cols-3 gap-4">
                    {Object.values(gallery[selectedYear][selectedMonth]).map((image) => (
                        <div key={image.file_id} className="border p-2">
                            <img src={`https://api.telegram.org/file/bot<YOUR_BOT_TOKEN>/${image.file_id}`} 
                                 alt={image.caption} />
                            <p className="font-bold">{image.date}</p>
                            <p>{image.title}</p>
                            <p>{image.caption}</p>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
}
