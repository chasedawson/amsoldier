const initialize = () => {
    console.log("in initialize");
    var data; 
    loadData().then(files => {
        console.log("success!");
        data = files[0];
        console.log(data);
    }).catch(err => {
        console.log(err);
    })
}

const loadData = () => {
    console.log("in loadData");
    return Promise.all([
        d3.csv("../data/cooc32144_b_edgelist.csv"),
    ]);
}