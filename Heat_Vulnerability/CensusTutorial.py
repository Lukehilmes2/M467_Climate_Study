import pandas as pd
import cenpy as cen
import pysal

datasets = list(cen.explorer.available(verbose=True).items())

# print first rows of the dataframe containing datasets
#print(pd.DataFrame(datasets).head(),"\n")
dataset = 'ACSSF5Y2010'
print(cen.explorer.explain(dataset),"\n")

con = cen.base.Connection(dataset)

print(con,"\n")

print(type(con),"\n")
print(type(con.geographies),"\n")
print(con.geographies.keys(),"\n")

print(con.geographies['fips'].head(),"\n")

#g_unit specifies scale at which data should be taken
#g_filter creates a filter so too much data is not downloaded
g_unit = 'county'
g_filter = {'state':'30'}

var = con.variables
print('Number of variables in',dataset,':',len(var),"\n")
print(con.variables.head(),"\n")

cols = con.varslike('b01001a_')
cols.extend(['NAME','GEOID'])

data = con.query(cols,geo_unit = g_unit,geo_filter = g_filter)

data.index = data.NAME

print(data.ix[:5,-5:],"\n")
print(cen.tiger.available(),"\n")

con.set_mapservice('tigerWMS_ACS2013')

# print layers
for key in con.mapservice.layers:
    {
    print(key,":",con.mapservice.layers[key])
    }

geodata = con.mapservice.query(layer = 8, where = 'COUNTY=063')
print(geodata.ix[:5,-5:],"\n")

newdata = pd.merge(data,geodata,left_on = 'county',right_on = 'COUNTY')

print(newdata.ix[:5,:-5],"\n")

newdata.to_csv(path_or_buf = "Missoula_County.csv",sep = ",")

