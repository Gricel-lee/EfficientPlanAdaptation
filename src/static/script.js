// Developer: Gricel Vazquez
// Last updated: 2025-08-28

// Note: For quick tests, after modifying hard reset website with:
// Ctrl+Shift+R (Windows/Linux) or Cmd+Shift+R (Mac)

// --- DOM Elements ---
const app = document.getElementById('app');
const problemsListView = document.getElementById('problems-list-view');
const problemDetailView = document.getElementById('problem-detail-view');
const problemsContainer = document.getElementById('problems-container');
const backButton = document.getElementById('back-button');
const loadingSpinner = document.getElementById('loading-spinner');
const confirmationModal = document.getElementById('confirmation-modal');
const confirmDeleteBtn = document.getElementById('confirm-delete-btn');
const cancelDeleteBtn = document.getElementById('cancel-delete-btn');
const createProblemForm = document.getElementById('create-problem-form');
const createProblemBtn = document.getElementById('create-problem-btn');
//add create-problem-from-text-btn
//add "create-from-text-checkbox
// add create-problem-from-text-wrapper
// create-problem-from-text-form
const createFromTextCheckbox = document.getElementById('create-from-text-checkbox');
const createProblemFromTextWrapper = document.getElementById('problem-text-input');
const createProblemFromTextBtn = document.getElementById('create-problem-from-text-btn');
const createProblemFromTextForm = document.getElementById('create-problem-from-text-form');
const textFormSpinner = document.getElementById('text-form-spinner');

// Plot views and elements
const plotLoadingView = document.getElementById('plot-loading-view');
const plotErrorView = document.getElementById('plot-error-view');
const plotChartView = document.getElementById('plot-chart-view');
const plotLoadingStatus = document.getElementById('plot-loading-status');
const plotErrorTitle = document.getElementById('plot-error-title');
const plotErrorMessage = document.getElementById('plot-error-message');


// --- State ---
let chartInstance = null; // To hold the Chart.js instance
let problemIdToDelete = null; // To hold the ID of the problem to be deleted
let detailViewInterval = null; // To hold the polling interval for the detail view
let listViewInterval = null; // To hold the polling interval for the list view

// --- API Functions ---

// Create problem from JSON file path
async function createProblem(description, jsonFilePath) {
    createProblemBtn.disabled = true;
    createProblemBtn.textContent = 'Creating...';
    try {
        const response = await fetch('/api/problems/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ description: description, json_file: jsonFilePath })
        });
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        createProblemForm.reset();
        fetchAllProblems();
    } catch (error) {
        console.error("Failed to create problem:", error);
        alert('Failed to create problem. Check console for details.');
    } finally {
        createProblemBtn.disabled = false;
        createProblemBtn.textContent = 'Create Problem';
    }
}

// Create problem from text input, not JSON file
async function createProblemFromText(description, naturalLanguageText) {
    console.log("[DEBUG] createProblemFromText called");
    console.log("[DEBUG] Text length:", naturalLanguageText.length);
    createProblemFromTextBtn.disabled = true;
    createProblemFromTextBtn.classList.add('hidden');
    // Show the loading spinner
    if (textFormSpinner) textFormSpinner.classList.remove('hidden');
    try {
        const response = await fetch('/api/problems/from-text/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ description: description, text: naturalLanguageText })
        });
        console.log("[DEBUG] Response status:", response.status);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        fetchAllProblems();
    } catch (error) {
        console.error("Failed to create problem from text:", error);
        alert('Failed to create problem from text. Check console for details.');
    } finally {
        // Hide the loading spinner and restore button
        if (textFormSpinner) textFormSpinner.classList.add('hidden');
        createProblemFromTextBtn.disabled = false;
        createProblemFromTextBtn.classList.remove('hidden');
    }
}

async function fetchAllProblems() {
    if (!problemsContainer.innerHTML.trim() && loadingSpinner) {
        loadingSpinner.classList.remove('hidden');
    }
    
    try {
        // To ensure the browser fetches fresh data for status updates, we explicitly tell it not to use its cache for this request.
        const response = await fetch('/api/problems/', {
            cache: 'no-store', // Or 'reload'
            headers: {
                'Cache-Control': 'no-cache',
                'Pragma': 'no-cache'
            }
        });
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const problems = await response.json();
        renderProblemsList(problems);
    } catch (error) {
        console.error("Failed to fetch problems:", error);
        problemsContainer.innerHTML = `<p class="text-red-500 col-span-full">Failed to load problems. Make sure the API is running.</p>`;
    } finally {
        if(loadingSpinner) loadingSpinner.classList.add('hidden');
    }
}

async function fetchProblemById(problemId) {
    try {
        const response = await fetch(`/api/problems/${problemId}`);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        const problem = await response.json();
        renderProblemDetail(problem);
    } catch (error) {
        console.error(`Failed to fetch problem ${problemId}:`, error);
        if (detailViewInterval) clearInterval(detailViewInterval);
    }
}


/**
 * Fetches and renders the detailed output JSON for a completed problem
 * into the 'Additional Information' section.
 * @param {string} problemId - The ID of the problem.
 */
async function fetchAndRenderJSONOutput(problemId) {
    const additionalInfoContainer = document.getElementById('detail-additional');
    const additionalInfoParent = additionalInfoContainer.parentElement;

    try {
        const response = await fetch(`/api/problems/${problemId}/output_json`);

        if (response.status === 404) {
            additionalInfoParent.classList.add('hidden');
            return;
        }
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        let data = await response.json();

        // --- NEW: Fix for formatting ---
        // If the fetched data is a string, it means we have a JSON string
        // inside a JSON response. We need to parse it one more time.
        if (typeof data === 'string') {
            data = JSON.parse(data);
        }
        // --- End of fix ---

        if (data && Object.keys(data).length > 0) {
            // Now, stringify the true JSON object with pretty-printing (2 spaces for indentation)
            const formattedJson = JSON.stringify(data, null, 2);
            
            // By placing the formatted text inside a <pre> tag, the browser
            // will respect all the spaces and newlines, giving you a clean look.
            additionalInfoContainer.innerHTML = `<pre>${formattedJson}</pre>`;
            additionalInfoParent.classList.remove('hidden');
        } else {
            additionalInfoParent.classList.add('hidden');
        }
    } catch (error) {
        console.error(`Failed to fetch additional data for ${problemId}:`, error);
        additionalInfoContainer.innerHTML = `<p class="text-red-500">Failed to load additional output data.</p>`;
        additionalInfoParent.classList.remove('hidden');
    }
}


// //@deprecated
// async function fetchPlotData(problemId) {
//     try {
//         const response = await fetch(`/api/problems/${problemId}/results`);
//         if (!response.ok) {
//             const errorData = await response.json().catch(() => ({ detail: 'Could not parse error response.' }));
//             throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
//         }
//         const plotData = await response.json();
        
//         if (plotData.x_values && plotData.y_values && plotData.x_label && plotData.y_label) {
//             const scatterData = plotData.x_values.map((x, i) => ({ x: x, y: plotData.y_values[i] }));
//             renderPlot(scatterData, plotData.x_label, plotData.y_label);
//         } else {
//             throw new Error("Invalid plot data format from API.");
//         }

//     } catch (error) {
//         console.error("Failed to fetch or render plot data:", error);
//         plotChartView.classList.add('hidden');
//         plotErrorView.classList.remove('hidden');
//         plotErrorTitle.textContent = "Plotting Error";
//         plotErrorMessage.textContent = error.message;
//     }
// }



// @deprecated
// /**
//  * Fetches the combined plot data (Pareto Set and Front) from the FastAPI backend.
//  */
// async function fetchPlotData(problemId) {
//             try {
//                 // In a real app, you would use a dynamic problemId.
//                 // For this example, it's hardcoded to match the backend mock.
//                 const response = await fetch(`/api/problems/${problemId}/results`);
                
//                 if (!response.ok) {
//                     const errorData = await response.json().catch(() => ({ detail: 'Could not parse error response.' }));
//                     throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
//                 }
                
//                 const plotData = await response.json();
                
//                 if (plotData.x_values && plotData.y_values && plotData.x_label && plotData.y_label) {
//                     const scatterData = plotData.x_values.map((x, i) => ({ x: x, y: plotData.y_values[i] }));
//                     renderPlot(scatterData, plotData.x_label, plotData.y_label, plotData.set_data);

//                     // Ensure the correct view is visible
//                     plotChartView.classList.remove('hidden');
//                     plotErrorView.classList.add('hidden');

//                 } else {
//                     throw new Error("Invalid plot data format from API.");
//                 }

//             } catch (error) {
//                 console.error("Failed to fetch or render plot data:", error);
//                 plotChartView.classList.add('hidden');
//                 plotErrorView.classList.remove('hidden');
//                 plotErrorTitle.textContent = "Plotting Error";
//                 plotErrorMessage.textContent = error.message;
//             }
//         }


/**
 * Fetches the combined plot data (Pareto Set and Front) from the FastAPI backend.
 * Filters out duplicate (x, y, setData) combinations before rendering.
 */
async function fetchPlotData(problemId) {
            try {
                // Get plot data from the backend API
                const response = await fetch(`/api/problems/${problemId}/results`);
                // Check for HTTP errors
                if (!response.ok) {
                    const errorData = await response.json().catch(() => ({ detail: 'Could not parse error response.' }));
                    throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
                }
                // Parse the JSON response
                const plotData = await response.json();
                
                // Validate the primary plot data (x_values, y_values, labels), if they exist continue
                if (plotData.x_values && plotData.y_values && plotData.x_label && plotData.y_label) {
                    
                    // --- NEW: Filter for unique (x, y, setData) combinations ---
                    const uniqueSignatures = new Set();
                    const uniqueScatterData = [];
                    const uniqueSetDataValues = [];
                    const hasSetData = plotData.set_data && plotData.set_data.values && plotData.set_data.values.length > 0;

                    // Iterate over all data points to filter for unique combinations
                    plotData.x_values.forEach((x, i) => {
                        const y = plotData.y_values[i];
                        const setDataRow = hasSetData ? plotData.set_data.values[i] : null;

                        // Create a unique signature string for the combination of x, y, and the setData row
                        const signature = `${x}-${y}-${JSON.stringify(setDataRow)}`;

                        // If we haven't seen this combination before, add it to our unique data arrays
                        if (!uniqueSignatures.has(signature)) {
                            uniqueSignatures.add(signature);
                            uniqueScatterData.push({ x: x, y: y });
                            if (hasSetData) {
                                uniqueSetDataValues.push(setDataRow);
                            }
                        }
                    });

                    // Reconstruct the setData object with only the unique values
                    const filteredSetData = hasSetData ? {
                        labels: plotData.set_data.labels,
                        values: uniqueSetDataValues
                    } : null;
                    
                    // Pass the newly filtered unique data to the render function
                    renderPlot(uniqueScatterData, plotData.x_label, plotData.y_label, filteredSetData, problemId);

                    // Ensure the correct view is visible
                    plotChartView.classList.remove('hidden');
                    plotErrorView.classList.add('hidden');

                } else {
                    throw new Error("Invalid plot data format from API.");
                }

            } catch (error) {
                console.error("Failed to fetch or render plot data:", error);
                plotChartView.classList.add('hidden');
                plotErrorView.classList.remove('hidden');
                plotErrorTitle.textContent = "Plotting Error";
                plotErrorMessage.textContent = error.message;
            }
        }

async function handleConfirmDelete() {
    if (!problemIdToDelete) return;
    try {
        const response = await fetch(`/api/problems/${problemIdToDelete}`, { method: 'DELETE' });
        if (!response.ok) {
            const errorData = await response.json().catch(() => null);
            throw new Error(`HTTP error! status: ${response.status}, detail: ${errorData?.detail}`);
        }
        fetchAllProblems();
    } catch (error) {
        console.error(`Failed to delete problem ${problemIdToDelete}:`, error);
        alert('Failed to delete problem. Check the console for details.');
    } finally {
        hideDeleteConfirmation();
    }
}

// --- Rendering Functions ---

function renderProblemsList(problems) {
    problemsContainer.innerHTML = '';
    if (problems.length === 0) {
        problemsContainer.innerHTML = `<p class="text-gray-500 col-span-full">No problems found. Create one.</p>`;
        return;
    }
    problems.sort((a, b) => new Date(b.date_creation) - new Date(a.date_creation));
    problems.forEach(problem => {
        const card = document.createElement('div');
        card.className = 'relative bg-white p-6 rounded-xl shadow-lg cursor-pointer transition-transform transform hover:-translate-y-1 hover:shadow-xl';
        card.dataset.id = problem.id;
        const statusColor = {
            created: 'bg-blue-100 text-blue-800',
            processing: 'bg-yellow-100 text-yellow-800 animate-pulse',
            completed: 'bg-green-100 text-green-800',
            failed: 'bg-red-100 text-red-800'
        }[problem.status] || 'bg-gray-100 text-gray-800';
        card.innerHTML = `
            <button class="delete-btn absolute top-3 right-3 p-1 text-gray-400 hover:text-red-600 hover:bg-red-100 rounded-full transition-colors focus:outline-none">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
            <div class="flex justify-between items-start mb-2">
                <h3 class="text-xl font-bold text-gray-800 truncate pr-8">${problem.description}</h3>
                <span class="text-xs font-semibold px-2.5 py-0.5 rounded-full ${statusColor}">${problem.status}</span>
            </div>
            <p class="text-sm text-gray-500 mb-4 font-mono">${problem.id}</p>
            <p class="text-sm text-gray-600">Created: ${new Date(problem.date_creation).toLocaleString()}</p>
        `;
        card.addEventListener('click', () => showDetailView(problem.id));
        const deleteButton = card.querySelector('.delete-btn');
        deleteButton.addEventListener('click', (event) => {
            event.stopPropagation();
            showDeleteConfirmation(problem.id);
        });
        problemsContainer.appendChild(card);
    });
}

/* Renders the problem detail view based on the problem's status.
    Also initiates fetching of additional data and plot data as needed. */
function renderProblemDetail(problem) {
    if (detailViewInterval) clearInterval(detailViewInterval);
    document.getElementById('detail-title').textContent = problem.description;
    document.getElementById('detail-id').textContent = `ID: ${problem.id}`;
    document.getElementById('detail-log').innerHTML = `<pre>${JSON.stringify(problem, null, 2)}</pre>`;
    // Hide the "Additional Information" section by default each time app renders
    document.getElementById('detail-additional').parentElement.classList.add('hidden');

    // Hide and clear the Plan Explanation section for the new problem
    const explanationSection = document.getElementById('plan-explanation-section');
    explanationSection.classList.add('hidden');
    document.getElementById('plan-explanation').innerHTML = '';

    plotLoadingView.classList.add('hidden');
    plotErrorView.classList.add('hidden');
    plotChartView.classList.add('hidden');

    if (problem.status === 'created' || problem.status === 'processing') {
        plotLoadingStatus.textContent = `Status: ${problem.status}`;
        plotLoadingView.classList.remove('hidden');
        detailViewInterval = setInterval(() => fetchProblemById(problem.id), 3000);
    } else if (problem.status === 'failed') {
        plotErrorView.classList.remove('hidden');
        plotErrorTitle.textContent = "Processing Failed";
        plotErrorMessage.textContent = "Error. " + (problem.error_message || "An unknown error occurred.");
    } else if (problem.status === 'completed') {
        plotChartView.classList.remove('hidden');
        fetchPlotData(problem.id);
        fetchAndRenderJSONOutput(problem.id); // Fetch and display the final JSON
        fetchTimelineData(problem.id); // Fetch and display the timeline data
    } else {
        plotErrorView.classList.remove('hidden');
        plotErrorTitle.textContent = 'Unknown Status';
        plotErrorMessage.textContent = `The problem has an unrecognized status: ${problem.status}`;
    }
}

//@deprecated
// function renderPlot(data, xLabel, yLabel) {
//     const ctx = document.getElementById('performance-chart').getContext('2d');
//     if (chartInstance) chartInstance.destroy();
//     chartInstance = new Chart(ctx, {
//         type: 'scatter',
//         data: {
//             datasets: [{
//                 label: 'Pareto Front Results',
//                 data: data,
//                 backgroundColor: 'rgba(54, 162, 235, 0.6)',
//                 borderColor: 'rgba(54, 162, 235, 1)',
//             }]
//         },
//         options: {
//             scales: {
//                 x: {
//                     type: 'linear',
//                     position: 'bottom',
//                     title: {
//                         display: true,
//                         text: xLabel || 'Objective 1'
//                     }
//                 },
//                 y: {
//                     title: {
//                         display: true,
//                         text: yLabel || 'Objective 2'
//                     }
//                 }
//             },
//             responsive: true,
//             maintainAspectRatio: false
//         }
//     });
// }


/**
 * Renders the scatter plot with interactive tooltips using Chart.js.
 * @param {Array} scatterData - The data for the plot, e.g., [{x: 1, y: 10}, ...].
 * @param {string} xLabel - The label for the X-axis.
 * @param {string} yLabel - The label for the Y-axis.
 * @param {Object|null} setData - The supplementary data for tooltips.
 */
function renderPlot(scatterData, xLabel, yLabel, setData, problemId) {

    const ctx = document.getElementById('performance-chart').getContext('2d');

    // If a chart instance already exists, destroy it to prevent conflicts
    if (chartInstance) {
        chartInstance.destroy();
    }

    chartInstance = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [{
                label: 'Problem Execution',
                data: scatterData,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                // borderWidth: 1,
                // pointRadius: 5,
                // pointHoverRadius: 7
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
                x: {
                    title: {
                        display: true,
                        text: xLabel,
                        font: {
                            // size: 16,
                            weight: 'bold'
                        }
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: yLabel,
                        font: {
                            // size: 16,
                            weight: 'bold'
                        }
                    }
                }
            },
            plugins: {
                    legend: {
                        display: false // Hide the legend as there's only one dataset
                    },
                    tooltip: {
                        enabled: false // Disable built-in tooltip, use click-based custom tooltip
                    }
                },
            // Handle click on chart points
            onClick: function(event, elements) {
            const tooltipEl = document.getElementById('chart-tooltip');
            const tooltipContent = document.getElementById('chart-tooltip-content');

            if (elements.length === 0) {
                // Clicked on empty area - hide tooltip
                tooltipEl.classList.add('hidden');
                return;
            }

            // Get clicked point coordinates
            const element = elements[0];
            const dataIndex = element.index;
            const dataPoint = scatterData[dataIndex];
            const xValue = dataPoint.x;
            const yValue = dataPoint.y;

            // Find ALL solutions that share this (x, y) coordinate
            const matchingIndices = [];
            scatterData.forEach((pt, idx) => {
                if (pt.x === xValue && pt.y === yValue) {
                    matchingIndices.push(idx);
                }
            });

            // Build tooltip header with coordinates and close button
            let html = `<div class="flex justify-between items-start mb-2 pb-2 border-b border-gray-600">
                <div>
                    <div class="text-gray-300 text-xs">${xLabel}: ${xValue}</div>
                    <div class="text-gray-300 text-xs">${yLabel}: ${yValue}</div>
                    <div class="text-gray-400 text-xs mt-1">${matchingIndices.length} solution${matchingIndices.length > 1 ? 's' : ''} at this point</div>
                </div>
                <button onclick="closeChartTooltip()" class="text-gray-400 hover:text-white text-lg font-bold ml-3 -mt-1">&times;</button>
            </div>`;

            // Render each matching solution with its parameters
            matchingIndices.forEach((solIdx, displayIdx) => {
                let pointSetData = null;
                if (setData && setData.values && solIdx < setData.values.length) {
                    pointSetData = setData.values[solIdx];
                }

                // Solution header with Explain button
                html += `<div class="${displayIdx > 0 ? 'mt-2 pt-2 border-t border-gray-700' : ''}">
                    <div class="flex items-center gap-2 mb-1">
                        <span class="font-semibold cursor-pointer hover:text-blue-300" onclick="handleSolutionSelect('${problemId}', ${solIdx}, ${pointSetData ? JSON.stringify(pointSetData).replace(/"/g, '&quot;') : '[]'})">Solution ${solIdx + 1}</span>
                        <button
                            class="px-2 py-0.5 bg-blue-500 hover:bg-blue-600 text-white rounded text-xs font-medium transition-colors"
                            onclick="handleSolutionSelect('${problemId}', ${solIdx}, ${pointSetData ? JSON.stringify(pointSetData).replace(/"/g, '&quot;') : '[]'})">
                            Explain
                        </button>
                    </div>`;

                // Parameters for this solution
                if (pointSetData) {
                    const labels = setData.labels || [];
                    html += `<div class="space-y-1 ml-2">`;
                    pointSetData.forEach((value, i) => {
                        const label = labels[i] || `Param ${i + 1}`;
                        html += `<button
                            class="w-full text-left px-2 py-1 rounded hover:bg-gray-700 transition-colors cursor-pointer text-xs"
                            onclick="handleTooltipItemClick(${solIdx}, ${i}, ${value}, '${label}')">
                            <span class="text-gray-400">${label}:</span> <span class="font-medium">${value}</span>
                        </button>`;
                    });
                    html += `</div>`;
                }

                html += `</div>`;
            });

            tooltipContent.innerHTML = html;

            // Position the tooltip near the clicked point
            const canvasRect = ctx.canvas.getBoundingClientRect();
            const clickX = event.native.clientX;
            const clickY = event.native.clientY;

            tooltipEl.style.left = clickX + window.pageXOffset + 15 + 'px';
            tooltipEl.style.top = clickY + window.pageYOffset - 10 + 'px';
            tooltipEl.classList.remove('hidden');
        }
        }
    });
}

/**
 * Close the chart tooltip
 */
function closeChartTooltip() {
    const tooltipEl = document.getElementById('chart-tooltip');
    if (tooltipEl) tooltipEl.classList.add('hidden');
}

/**
 * Handler for clicking on a parameter item in the tooltip.
 * @param {number} solutionIndex - The index of the solution point.
 * @param {number} paramIndex - The index of the parameter within the solution.
 * @param {number} value - The value of the parameter.
 * @param {string} label - The label of the parameter.
 */
function handleTooltipItemClick(solutionIndex, paramIndex, value, label) {
    console.log(`[Chart] Parameter clicked - Solution: ${solutionIndex + 1}, Parameter: ${label}, Value: ${value}`);
    // TODO: Add custom behavior for parameter clicks here
    // // Hide the tooltip
    // const tooltipEl = document.getElementById('chart-tooltip');
    // if (tooltipEl) tooltipEl.classList.add('hidden');
    // // Add your custom action here
    // // For example: highlight this parameter, copy to clipboard, show in detail panel, etc.
    // alert(`Selected parameter:\n${label}: ${value}\n\nFrom Solution ${solutionIndex + 1}`);
}

/**
 * Handler for selecting a complete solution from the tooltip.
 * @param {string} problemId - The ID of the problem.
 * @param {number} solutionIndex - The index of the solution point.
 * @param {Array} solutionData - The array of parameter values for this solution.
 */
async function handleSolutionSelect(problemId, solutionIndex, solutionData) {
    console.log(`[Chart] Solution selected - Problem: ${problemId}, Index: ${solutionIndex + 1}, Data:`, solutionData);

    // Hide the tooltip
    const tooltipEl = document.getElementById('chart-tooltip');
    if (tooltipEl) tooltipEl.classList.add('hidden');

    // Unhide the plan-explanation-section
    const explanationSection = document.getElementById('plan-explanation-section');
    explanationSection.classList.remove('hidden');

    // Show loading spinner inside the explanation box
    const explanationBox = document.getElementById('plan-explanation');
    explanationBox.innerHTML = `
        <div class="flex flex-col items-center justify-center h-full">
            <div class="animate-spin rounded-full h-10 w-10 border-4 border-blue-500 border-t-transparent"></div>
            <p class="mt-3 text-gray-500 text-sm">Generating explanation for Solution ${solutionIndex + 1}...</p>
        </div>`;

    try {
        const response = await fetch(`/api/problems/${problemId}/explain-solution`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                solution_index: solutionIndex,
                solution_data: solutionData,
                role: document.getElementById('user-type').value,
                format: document.getElementById('explanation-format').value,
                levelDetail: document.getElementById('explanation-detail').value,
                tone: document.getElementById('explanation-tone').value
            })
        });
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ detail: 'Unknown error' }));
            throw new Error(errorData.detail || `HTTP error ${response.status}`);
        }
        // Shown the explanation in the window
        const result = await response.json();
        explanationBox.innerHTML = `<p class="whitespace-pre-wrap">
        Explanation for Solution ${solutionIndex + 1}:        
        ${result.explanation}
        </p>`;
    } catch (error) {
        console.error('[Chart] Error fetching explanation:', error);
        explanationBox.innerHTML = `<p class="text-red-500">Error: ${error.message}. \nError when explaining solution ${solutionIndex + 1}.</p>`;
    }
}


// --- View & Modal Switching Logic ---

function showListView() {
    if (detailViewInterval) clearInterval(detailViewInterval);
    if (listViewInterval) clearInterval(listViewInterval);

    problemDetailView.classList.add('hidden');
    problemsListView.classList.remove('hidden');
    
    fetchAllProblems();
    
    listViewInterval = setInterval(fetchAllProblems, 5000);
}

function showDetailView(problemId) {
    if (listViewInterval) clearInterval(listViewInterval);

    problemsListView.classList.add('hidden');
    problemDetailView.classList.remove('hidden');
    fetchProblemById(problemId);
}

function showDeleteConfirmation(problemId) {
    problemIdToDelete = problemId;
    confirmationModal.classList.remove('hidden');
}

function hideDeleteConfirmation() {
    problemIdToDelete = null;
    confirmationModal.classList.add('hidden');
}






// --- Timeline Functions ---
async function fetchTimelineData(problemId) {
    // Hide the timeline section by default until we confirm we have data
    const timelineSection = document.getElementById('timeline-section');
    timelineSection.classList.add('hidden');
    try {
        const response = await fetch(`/api/problems/${problemId}/timeline`, { cache: 'no-store' });
        
        // Silently exit if the timeline doesn't exist (e.g., 404 Not Found)
        if (!response.ok) {
            console.warn(`No timeline data available for problem ${problemId}. Status: ${response.status}`);
            return;
        }
        const timelineData = await response.json();
        // Only proceed if we received a valid array with at least one event
        if (Array.isArray(timelineData) && timelineData.length > 0) {
            timelineSection.classList.remove('hidden'); // Show the section
            renderTimeline(timelineData);
        } else {
            console.warn(`Timeline data for problem ${problemId} is empty or invalid.`);
        }

    } catch (error) {
        // Also ignore errors silently in the UI, but log for developers
        console.error(`Failed to fetch or render timeline for problem ${problemId}:`, error);
    }
}

/**
 * Renders timeline visualization using Google Charts.
 * Automatically replaces the <canvas> with a <div> for compatibility.
 */
function renderTimeline(timelineData) {
    let container = document.getElementById('timeline-chart');
    if (!container) {
        console.error('Timeline container element not found!');
        return;
    }
    // IMPORTANT: Google Timeline requires a DIV, not a CANVAS.
    // This code replaces the canvas with a div to make it work without changing the HTML.
    if (container.tagName.toUpperCase() === 'CANVAS') {
        const div = document.createElement('div');
        div.id = 'timeline-chart';
        div.style.height = `${container.getAttribute('height') || 300}px`; // Preserve height
        container.parentNode.replaceChild(div, container);
        container = div; // Update reference to the new div
    }

    const dataTable = new google.visualization.DataTable();
    dataTable.addColumn({ type: 'string', id: 'Agent' });
    dataTable.addColumn({ type: 'string', id: 'Action' });
    dataTable.addColumn({ type: 'string', role: 'tooltip', 'p': {'html': true} });
    dataTable.addColumn({ type: 'number', id: 'Start' });
    dataTable.addColumn({ type: 'number', id: 'End' });

    let maxTime = 0;
    const rows = timelineData.map(event => {
        const { action, agent, start_time, end_time, duration, details } = event;
        
        if (end_time > maxTime) maxTime = end_time;
        
        const barLabel = action === 'move'
            ? `Move: ${details.from} → ${details.to}`
            : `Task: ${details.task_id}`;
        
        // HTML tooltip that appears on hover
        const tooltipContent = `
            <div class="p-2 text-sm" style="min-width: 160px;">
                <div class="font-bold text-base mb-1">${agent} - ${action.charAt(0).toUpperCase() + action.slice(1)}</div>
                <hr class="my-1">
                <div><strong>Duration:</strong> ${duration.toFixed(1)} units</div>
                <div><strong>Time:</strong> ${start_time.toFixed(1)} to ${end_time.toFixed(1)}</div>
                ${action === 'move' ? `<div><strong>From:</strong> ${details.from}</div>` : ''}
                ${action === 'move' ? `<div><strong>To:</strong> ${details.to}</div>` : '' }
                ${action === 'dotask' ? `<div><strong>Location:</strong> ${details.location}</div>` : ''}
                ${action === 'dotask' ? `<div><strong>Task ID:</strong> ${details.task_id}</div>` : ''}
            </div>`;
        
        return [agent, barLabel, tooltipContent, start_time, end_time];
    });

    dataTable.addRows(rows);
    
    // Generate ticks for every 1 time step on the x-axis
    // @TODO: check why not showing
    const finalMaxTime = Math.ceil(maxTime * 1.05);
    const ticks = Array.from({length: finalMaxTime + 1}, (_, i) => i);

    // chart's appearance
    const options = {
        height: 300,
        width: '100%',
        timeline: {
            colorByRowLabel: true,
            barLabelStyle: { fontSize: 13 }, // Increased font size for bar labels
            groupByRowLabel: true
        },
        hAxis: {
            minValue: 0,
            maxValue: finalMaxTime,
            ticks: ticks,
            textStyle: { // Style for the horizontal axis (time steps)
                fontSize: 15
            }
        },
        vAxis: { // Style for the vertical axis (agent names)
            textStyle: {
                fontSize: 14,
                bold: true
            }
        },
        tooltip: {
            isHtml: true
        },
        avoidOverlappingGridLines: false,
    };
    
    try {
        const chart = new google.visualization.Timeline(container);
        chart.draw(dataTable, options);
    } catch (error) {
        console.error("Error drawing Google Timeline chart:", error);
        container.innerHTML = `<p class="text-red-500 p-4">Could not render the timeline chart.</p>`;
    }
}




// --- Event Listeners ---
backButton.addEventListener('click', showListView);
confirmDeleteBtn.addEventListener('click', handleConfirmDelete);
cancelDeleteBtn.addEventListener('click', hideDeleteConfirmation);
// --- Browse JSON File Button ---
document.getElementById('browse-file-btn').addEventListener('click', () => {
    document.getElementById('json-file-selector').click();
});

document.getElementById('json-file-selector').addEventListener('change', async (event) => {
    const file = event.target.files[0];
    if (!file) return;

    const browseBtn = document.getElementById('browse-file-btn');
    const originalText = browseBtn.textContent;
    browseBtn.disabled = true;
    browseBtn.textContent = 'Uploading...';

    try {
        const formData = new FormData();
        formData.append('file', file);

        const response = await fetch('/api/upload-json', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ detail: 'Upload failed' }));
            throw new Error(errorData.detail || `HTTP error ${response.status}`);
        }

        const result = await response.json();
        // Update the JSON file path input with the server-side path
        document.getElementById('problem-json-path').value = result.json_file_path;
        console.log(`[Upload] JSON file stored at: ${result.json_file_path}`);
    } catch (error) {
        console.error('[Upload] Failed to upload JSON file:', error);
        alert('Failed to upload JSON file. ' + error.message);
    } finally {
        browseBtn.disabled = false;
        browseBtn.textContent = originalText;
        // Reset file input so the same file can be selected again
        event.target.value = '';
    }
});

createProblemForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const description = document.getElementById('problem-description').value;
    const jsonFilePath = document.getElementById('problem-json-path').value;
    createProblem(description, jsonFilePath);
});

console.log("[DEBUG] createProblemFromTextForm element:", createProblemFromTextForm);
createProblemFromTextForm.addEventListener('submit', (event) => {
    event.preventDefault();
    const descriptionInput = document.getElementById('problem-description');
    const description = descriptionInput.value.trim();
    const naturalLanguageText = document.getElementById('problem-text-input').value;

    // Validate description field is filled
    if (!description) {
        descriptionInput.reportValidity();
        return;
    }

    console.log("[DEBUG] Description:", description);
    console.log("[DEBUG] Text length:", naturalLanguageText.length);
    createProblemFromText(description, naturalLanguageText);
});

// --- Initial Load ---
document.addEventListener('DOMContentLoaded', () => {
    showListView();
});
