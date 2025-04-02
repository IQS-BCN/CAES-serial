import pandas as pd
import numpy as np
from math import atan2, degrees

def angle(p):
    """Calculate the angle between three points"""
    #formula extracted from https://stackoverflow.com/questions/35176451/python-code-to-calculate-angle-between-three-point-using-their-3d-coordinates
    
    p1 = p[0]
    p2 = p[1]
    p3 = p[2]

    ba = p1 - p2
    bc = p3 - p2

    cosine_angle = np.dot(ba, bc) / (np.linalg.norm(ba) * np.linalg.norm(bc))
    angle = np.arccos(cosine_angle)

    return np.degrees(angle)


def dihedral(p):
    #formula extracted from https://stackoverflow.com/questions/20305272/dihedral-torsion-angle-from-four-points-in-cartesian-coordinates-in-python
    """Praxeolitic formula
    1 sqrt, 1 cross product"""
    p0 = p[0]
    p1 = p[1]
    p2 = p[2]
    p3 = p[3]

    b0 = -1.0*(p1 - p0)
    b1 = p2 - p1
    b2 = p3 - p2

    # normalize b1 so that it does not influence magnitude of vector
    # rejections that come next
    b1 /= np.linalg.norm(b1)

    # vector rejections
    # v = projection of b0 onto plane perpendicular to b1
    #   = b0 minus component that aligns with b1
    # w = projection of b2 onto plane perpendicular to b1
    #   = b2 minus component that aligns with b1
    v = b0 - np.dot(b0, b1)*b1
    w = b2 - np.dot(b2, b1)*b1

    # angle between v and w in a plane is the torsion angle
    # v and w may not be normalized but that's fine since tan is y/x
    x = np.dot(v, w)
    y = np.dot(np.cross(b1, v), w)
    return np.degrees(np.arctan2(y, x))

def distance(b,a):
    """JF -- Formula to calculate the distance between two points in the 3D space, 
    using RMSD formula"""
    ax = a[0]
    ay = a[1]
    az = a[2]

    bx = b[0]
    by = b[1]
    bz = b[2]

     #calculate the distance between the gly_O and the C 
    dx = ax - bx
    dy = ay - by
    dz = az - bz
    #calculate the rmsd
    return np.sqrt(dx**2 + dy**2 + dz**2)


def ori_pos(r1, r2, r3, l1, l2 ,l3):
    d = distance(r1, l1)
    alpha = angle([l2, l1, r1])
    omega = dihedral([l2, l3, l1, r1])

    beta = angle([l1, r1, r2])
    theta = dihedral([l2, l1, r1, r2])
    gamma = dihedral([l1, r1, r2, r3])

    return d, alpha, omega, beta, theta, gamma