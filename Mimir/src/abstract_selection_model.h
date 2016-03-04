//
// Created by Vadim N. on 04/03/2016.
//

#ifndef MIMIR_ABSTRACT_SELECTION_MODEL_H
#define MIMIR_ABSTRACT_SELECTION_MODEL_H


#include <vector>
#include <fstream>

#include <Ymir/Graph>


using namespace ymir;


namespace mimir {


    typedef std::string string_t;


    typedef double Qvalue;
    typedef std::vector<Qvalue> QvalueVec;


    typedef Json::Value ModelParameters;


    class AbstractSelectionModel {

    public:


        AbstractSelectionModel()
        {
        }


        AbstractSelectionModel(const ModelParameters &params)
            : _parameters(params)
        {
        }


        virtual Qvalue predict(const Clonotype& clonotype) const = 0;


        virtual QvalueVec predict(const ClonesetView &cloneset) const {
            QvalueVec res;
            res.reserve(cloneset.size());
            for (size_t i = 0; i < cloneset.size(); ++i) {
                if (cloneset[i].isCoding()) {
                    res.push_back(this->predict(cloneset[i]));
                } else {
                    res.push_back(0);
                }
            }
            return res;
        }


        bool read(const string_t &filepath) {
            std::ifstream stream(filepath);
            if (stream.is_open()) {
                stream >> _parameters;
                return true;
            }
            return false;
        }


        bool write(const string_t &filepath) {
            std::ifstream stream(filepath);
            if (stream.is_open()) {
                stream << _parameters;
                return true;
            }
            return false;
        }

        const ModelParameters& parameters() const { return _parameters; }


        void set_parameters(const ModelParameters &params) { _parameters = params; }

    protected:

        ModelParameters _parameters;

    };
}


#endif //MIMIR_ABSTRACT_SELECTION_MODEL_H
